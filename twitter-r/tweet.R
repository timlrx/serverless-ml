library(rtweet)
library(dplyr)
library(ggplot2)
library(tidytext)
library(tidyr)
library(stringr)

## https://rtweet.info/articles/auth.html
## authenticate via web browser
authenticate <- function() {
  token <- create_token(
    app = "snowyowl",
    consumer_key = Sys.getenv("API_KEY"),
    consumer_secret = Sys.getenv("API_SECRET_KEY"),
    access_token = Sys.getenv("ACCESS_TOKEN"),
    access_secret = Sys.getenv("ACCESS_SECRET")
  )
  return(token)
}	

get_tweets <- function(account_vector, n, token) {
  return(get_timelines(account_vector, n, token=token))
}

plot_tweet_trends <- function(tmls) {
  account_list_str = paste(unlist(tmls['screen_name'] %>% unique()), collapse=", ")
  
  ## plot the frequency of tweets for each user over time
  p <- tmls %>%
    filter(created_at > "2017-10-29") %>%
    group_by(screen_name) %>%
    ts_plot("days", trim = 1L) +
    geom_point() +
    theme_minimal() +
    theme(
      legend.title = ggplot2::element_blank(),
      legend.position = "bottom",
      plot.title = ggplot2::element_text(face = "bold")) +
    labs(
      x = NULL, y = NULL,
      title = "Frequency of Twitter Actitity by Accounts",
      subtitle = paste("Tweets aggregated by day for the following accounts:", account_list_str)
    )
  
  return(p)
}

plot_sentiment_trends <- function(tmls) {
  tidy_tweets <- tmls %>%
    select(text, screen_name, created_at, status_id) %>%
    group_by(screen_name) %>%
    mutate(linenumber = row_number(),
           day = substr(created_at,0,10)) %>%
    ungroup() %>%
    unnest_tokens(word, text)
  
  tweet_sentiment <- tidy_tweets %>%
    inner_join(get_sentiments("bing"), by="word") %>%
    group_by(screen_name, day, sentiment) %>%
    tally() %>%
    spread(sentiment, n, fill = 0) %>%
    ungroup() %>%
    mutate(sentiment = positive - negative,
           day = as.Date(day))
  
  p <- ggplot(tweet_sentiment, aes(day, sentiment, fill = screen_name)) +
    geom_col(show.legend = FALSE) +
    scale_x_date(date_labels = "%b %d") +
    facet_wrap(~screen_name, ncol = 1, scales = "free_x") +
    theme_minimal() +
    theme(
      legend.title = ggplot2::element_blank(),
      legend.position = "bottom",
      plot.title = ggplot2::element_text(face = "bold")) +
    labs(
      x = NULL, y = NULL,
      title = "Sentiment Analysis of Accounts"
    )
    
  return(p)
}

## Sample usage
token <- authenticate()
tmls <- get_tweets(c("BBCWorld", "realDonaldTrump"), n = 500, token)
plot_tweet_trends(tmls)
plot_sentiment_trends(tmls)


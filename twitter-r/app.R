library(plotly)
source("tweet.R")

#* CORS allows requests made from external urls to be accepted
#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}

#* Health check
#* @get /health
function(req, res){
  res$status <- 200
}

#* Plot tweet frequency over time
#* @param users Comma seperated list of user name or IDs
#* @param n Number of tweets (max 3200)
#* @png
#* @get /frequency
function(users="", n=400){
  users_vector <- strsplit(users, ",")[[1]]
  token <- authenticate()
  tmls <- get_tweets(users_vector, min(3200, as.numeric(n)), token)
  plot_tweet_trends(tmls) %>% print()
}

#* Plot tweet frequency over time (interactive)
#* @param users Comma seperated list of user name or IDs
#* @param n Number of tweets (max 3200)
#* @serializer htmlwidget
#* @get /html/frequency
function(users="", n=400){
  users_vector <- strsplit(users, ",")[[1]]
  token <- authenticate()
  tmls <- get_tweets(users_vector, min(3200, as.numeric(n)), token)
  plot_tweet_trends(tmls) %>% ggplotly()
}


#* Plot sentiment trends over time
#* @param users Comma seperated list of user name or IDs
#* @param n Number of tweets (max 3200)
#* @png
#* @get /sentiment
function(users="", n=400){
  users_vector <- strsplit(users, ",")[[1]]
  token <- authenticate()
  tmls <- get_tweets(users_vector, min(3200, as.numeric(n)), token)
  plot_sentiment_trends(tmls) %>% print()
}

#* Plot sentiment trends over time (interactive)
#* @param users Comma seperated list of user name or IDs
#* @param n Number of tweets (max 3200)
#* @serializer htmlwidget
#* @get /html/sentiment
function(users="", n=400){
  users_vector <- strsplit(users, ",")[[1]]
  token <- authenticate()
  tmls <- get_tweets(users_vector, min(3200, as.numeric(n)), token)
  plot_sentiment_trends(tmls) %>% ggplotly()
}

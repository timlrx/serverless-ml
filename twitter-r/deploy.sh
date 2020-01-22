#!/bin/bash
# Script to build and deploy docker file to cloud run
# To run locally:
#   docker run -p 8000:8000 -e PORT=8000 -e API_KEY -e API_SECRET_KEY -e ACCESS_TOKEN -e ACCESS_SECRET ${IMAGE}

IMAGE=twitter-r
PROJECT_ID=$(gcloud config get-value project)

# Build and upload the image to google container repository
docker build -t ${IMAGE} .
docker tag ${IMAGE} gcr.io/${PROJECT_ID}/${IMAGE}:1.0.0
gcloud docker -- push gcr.io/${PROJECT_ID}/${IMAGE}:1.0.0

# Deploy cloud run
gcloud alpha run deploy \
    --image="gcr.io/${PROJECT_ID}/${IMAGE}:1.0.0" \
    --region="us-central1" \
    --platform managed \
    --memory=512Mi \
    --port=8000 \
    --set-env-vars API_KEY=${API_KEY},API_SECRET_KEY=${API_SECRET_KEY},ACCESS_TOKEN=${ACCESS_TOKEN},ACCESS_SECRET=${ACCESS_SECRET} \
    --allow-unauthenticated

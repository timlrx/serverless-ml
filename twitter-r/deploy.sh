#!/bin/bash
# Script to build and deploy docker file to cloud run

PROJECT_ID=$(gcloud config get-value project)

gcloud builds submit \
    --tag="gcr.io/${PROJECT_ID}/helloworld"

gcloud run deploy \
    --image="gcr.io/${PROJECT_ID}/helloworld" \
    --region="us-central1" \
    --platform managed \
    --set-env-vars=[PORT=8000] \
    --allow-unauthenticated

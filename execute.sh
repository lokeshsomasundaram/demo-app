#!/bin/bash

echo "Cleaning up old container..."
docker ps -q -f name=demo-app-container | xargs -r docker stop
docker ps -aq -f name=demo-app-container | xargs -r docker rm
docker container prune -f

echo "Building Docker image..."
docker build -t demo-app-image .

echo "Starting container on port 8085..."
docker run -d --name demo-app-container -p 8085:80 demo-app-image

echo "Waiting 5 seconds for the app to start..."
sleep 5

echo "Verifying the app..."
curl -f http://localhost:8085 || { echo "App failed to start"; exit 1; }

echo "App is running on port 8085!"

#!/bin/bash

echo "Cleaning up old container..."
docker ps -q -f name=demo-app-container | xargs -r docker stop
docker ps -aq -f name=demo-app-container | xargs -r docker rm
docker container prune -f

echo "Building Docker image..."
docker build -t demo-app-image .

echo "Starting container on port 8085..."
docker run -d --name demo-app-container -p 8085:80 demo-app-image

echo "Waiting for the app to start..."
for i in {1..10}; do
    if curl -s http://localhost:8085 > /dev/null; then
        echo "App is running on port 8085!"
        break
    else
        echo "App not ready yet, waiting 2 seconds..."
        sleep 2
    fi
done

# Final check; fail if still not responding
curl -f http://localhost:8085 || { echo "App failed to start"; exit 1; }

echo "✅ App successfully verified and running!"

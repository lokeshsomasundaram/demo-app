# Use official Python 3.11 slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy app
COPY app.py /app

# Install Flask
RUN pip install --no-cache-dir flask

# Expose container port 80
EXPOSE 80

# Run the Flask app
CMD ["python", "app.py"]

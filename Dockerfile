# Use a slim Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy app code
COPY app.py /app

# Install Flask
RUN pip install --no-cache-dir flask

# Expose default container port
EXPOSE 80

# Run the application
CMD ["python", "app.py"]

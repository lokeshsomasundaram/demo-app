# Use Python slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy application code
COPY app.py /app

# Install Flask
RUN pip install --no-cache-dir flask

# Expose port 80
EXPOSE 80

# Command to run the app
CMD ["python", "app.py"]

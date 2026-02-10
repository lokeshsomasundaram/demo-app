# Use Python slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy HTML file
COPY index.html /app

# Expose port 80
EXPOSE 80

# Use Python's simple HTTP server to serve HTML
CMD ["python", "-m", "http.server", "80"]

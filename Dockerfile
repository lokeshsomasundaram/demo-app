# Use official nginx image
FROM nginx:alpine

# Copy your HTML file into nginx default location
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start nginx (already the default CMD)

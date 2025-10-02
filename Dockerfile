# Use official Nginx image as base
FROM nginx:alpine

# Copy website files to Nginx default html directory
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

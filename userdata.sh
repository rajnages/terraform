#!/bin/bash
# Update the package list
sudo apt-get update -y

# Install Nginx
sudo apt-get install nginx -y

# Create a simple HTML file for the web app
echo "<h1>Welcome to the Terraform Deployed Web Application!</h1>" | sudo tee /var/www/html/index.html

# Enable and start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

#!/bin/bash

# Exit if any command fails
set -e

# Variables
DOMAIN="your_domain.com"  # Replace with your domain
EMAIL="your_email@example.com"  # Replace with your email address
NGINX_CONF="/etc/nginx/sites-available/flaskapp"  # Path to your Nginx config
FLASK_APP_PATH="/path/to/your/app"  # Path to your Flask app

# 1. Update system and install dependencies
echo "Updating system and installing dependencies..."
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y python3-pip python3-dev libssl-dev libffi-dev build-essential
sudo apt install -y nginx certbot python3-certbot-nginx

# 2. Install Flask (if you haven't done so yet)
echo "Installing Flask..."
pip3 install flask

# 3. Configure Nginx to proxy requests to Flask app
echo "Configuring Nginx..."
cat <<EOF | sudo tee $NGINX_CONF
server {
    listen 80;
    server_name $DOMAIN;  # Replace with your domain

    location / {
        proxy_pass http://127.0.0.1:5000;  # Flask app is running on port 5000
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable the Nginx site and restart the service
echo "Enabling Nginx site..."
sudo ln -s $NGINX_CONF /etc/nginx/sites-enabled/
sudo nginx -t  # Test Nginx configuration
sudo systemctl restart nginx  # Restart Nginx

# 4. Obtain SSL certificate using Certbot
echo "Obtaining SSL certificate using Certbot..."
sudo certbot --nginx -d $DOMAIN --email $EMAIL --agree-tos --no-eff-email

# 5. Set up automatic renewal for SSL certificates
echo "Setting up automatic certificate renewal..."
sudo certbot renew --dry-run

# 6. Restart Nginx after Certbot configuration
echo "Restarting Nginx to apply SSL changes..."
sudo systemctl restart nginx

# 7. Run Flask app behind Nginx (Optional: If you haven't already)
echo "Running Flask app in the background..."
cd $FLASK_APP_PATH
nohup python3 app.py &

echo "SSL installation and Flask app setup completed successfully!"

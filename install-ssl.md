Steps to Use the Script:

Replace the placeholder values:

Replace your_domain.com with your actual domain name.

Replace your_email@example.com with your email address.

Replace /path/to/your/app with the directory where your Flask app (app.py) is located.

Make the script executable:

Save the script as install_ssl.sh on your droplet and give it executable permissions:

`chmod +x install_ssl.sh`

Execute the script:

`./install_ssl.sh`

What This Script Does:

Updates the system: It makes sure your Ubuntu system is up-to-date and installs required dependencies (nginx, certbot, etc.).

Installs Flask: If you haven’t installed Flask yet, it will do so automatically.

Configures Nginx: The script creates an Nginx configuration to serve your Flask app. It sets up the reverse proxy to forward HTTP traffic to your Flask app, which is running on port 5000.

Obtain SSL certificates: It uses Certbot to obtain SSL certificates for your domain and configure Nginx for HTTPS.

Sets up auto-renewal: It ensures that your SSL certificate is renewed automatically by Certbot, so you don’t have to manually renew it.

Starts Flask app: It runs the Flask app (app.py) in the background using nohup so it continues running after the terminal session is closed.

Troubleshooting:

Certbot Issues: If Certbot encounters any issues, ensure your domain's DNS records are properly set up and pointing to the IP address of your droplet.

Nginx Errors: If Nginx doesn’t start, check the error logs with sudo journalctl -xe and verify the syntax in /etc/nginx/nginx.conf and /etc/nginx/sites-available/.
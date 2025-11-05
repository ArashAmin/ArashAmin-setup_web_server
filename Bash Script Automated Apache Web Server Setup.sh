#!/bin/bash

# Automated Web Server Setup Script for Ubuntu (Apache)
# Installs Apache, starts it, opens firewall port, and creates a custom index.html.
# Run with sudo.

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "Run this script with sudo."
   exit 1
fi

echo "Starting Apache Web Server setup..."

# Step 1: Update and install Apache
apt update -y
apt install apache2 -y
systemctl enable apache2
systemctl start apache2

# Step 2: Open firewall port 80
ufw allow 80/tcp
ufw reload

# Step 3: Create custom index.html
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head><title>Automated Web Server</title></head>
<body>
<h1>Success! Apache is running on Ubuntu Server.</h1>
<p>Setup by Bash script. Visit: http://YOUR_SERVER_IP</p>
<p>Date: $(date)</p>
</body>
</html>
EOF

# Step 4: Test locally
if curl -s localhost | grep -q "Success"; then
    echo "Web server test: PASSED"
else
    echo "Web server test: FAILED"
fi

# Step 5: Show status
systemctl status apache2 --no-pager -l | head -5
echo "Access your site at: http://$(hostname -I | awk '{print $1}')"

echo "Setup completed! Apache is ready."
#!/bin/bash
#
# setup_global_403.sh


set -e

# Detect Apache path
if [ -d "/etc/httpd" ]; then
    APACHE_CONF_DIR="/etc/httpd"
    SERVICE_NAME="httpd"
elif [ -d "/etc/apache2" ]; then
    APACHE_CONF_DIR="/etc/apache2"
    SERVICE_NAME="apache2"
else
    echo "Apache configuration directory not found. Exiting."
    exit 1
fi

CONF_FILE="$APACHE_CONF_DIR/conf.d/common-403.conf"
HTML_FILE="/var/www/html/custom_403.html"

echo "Apache config directory detected: $APACHE_CONF_DIR"
echo "Creating custom 403 error page: $HTML_FILE"
mkdir -p /var/www/html

# 1 Custom 403 HTML 
cat <<'EOF' > "$HTML_FILE"
<!DOCTYPE html>
<html>
<head><title>Error loading page</title></head>
<body>
<h1>Error loading page</h1>
<p>The server may be experiencing higher than normal use. Please wait a few seconds and try reloading the page.<p>
<p>If you continue having difficulty accessing the site, please contact the TDL Helpdesk at <a href="mailto:support@tdl.org">support@tdl.org</a>.</p>
</body>
</html>
EOF

chmod 644 "$HTML_FILE"

# Apache setting
echo "Creating global 403 configuration: $CONF_FILE"

cat <<'EOF' > "$CONF_FILE"
# ============================================================
# Global 403 Error Handling Configuration
# For mod_evasive or general forbidden access
# ============================================================

# Custom 403 page
ErrorDocument 403 /custom_403.html

# Serve the custom page
Alias /custom_403.html /var/www/html/custom_403.html

<Directory "/var/www/html">
    Require all granted
</Directory>

# Test path to trigger forbidden (for mod_evasive or testing)
<Location "/forbidden-test">
    Require all denied
</Location>

# Optional for reverse-proxy environments
ProxyErrorOverride On
ProxyPass /forbidden-test !
ProxyPass /custom_403.html !
EOF

chmod 644 "$CONF_FILE"

#checking
echo "Testing Apache configuration..."
if apachectl configtest 2>&1 | grep -q "Syntax OK"; then
    echo "Apache configuration syntax OK"
else
    echo "Apache configuration syntax error. Check output above."
    exit 1
fi

# restart apache
echo "Restarting Apache service..."
systemctl restart "$SERVICE_NAME"

echo "Done! Global 403 error page configured successfully."
echo "Test by visiting: http://<server_ip>/forbidden-test"

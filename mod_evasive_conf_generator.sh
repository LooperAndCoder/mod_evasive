#!/bin/bash

# Get public IP
PUBLIC_IP=$(curl -s ifconfig.me)

# Get private IP (first non-loopback IPv4)
PRIVATE_IP=$(hostname -I | awk '{print $1}')

# Output file
CONF_FILE="mod_evasive.conf"

# Create config file
cat <<EOF > $CONF_FILE
<IfModule mod_evasive20.c>
    DOSHashTableSize    3097
    DOSPageCount        10
    DOSSiteCount        100
    DOSPageInterval     1
    DOSSiteInterval     1
    DOSBlockingPeriod   30
    ErrorDocument 403 /custom_403.html
    DOSEmailNotify      c.kim@austin.utexas.edu
    DOSLogDir           "/var/log/mod_evasive"
    DOSLogUnblock On
    # Whitelist internal, loopback, and public IPs
    DOSWhitelist 127.0.0.1
    DOSWhitelist 54.227.247.150
    DOSWhitelist $PRIVATE_IP
    DOSWhitelist $PUBLIC_IP
</IfModule>
EOF

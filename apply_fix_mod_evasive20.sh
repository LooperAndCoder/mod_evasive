#!/bin/bash
set -e

RAW_URL="https://raw.githubusercontent.com/LooperAndCoder/mod_evasive/master/mod_evasive20.c"
BUILD_DIR="/usr/local/src/mod_evasive_update"
HTTPD_SERVICE="httpd"

echo "==> Creating build directory..."
sudo rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd $BUILD_DIR

echo "==> Downloading latest mod_evasive20.c..."
curl -L -o mod_evasive20.c $RAW_URL

echo "==> Recompiling and installing module..."
sudo apxs -c -i mod_evasive20.c

echo "==> Testing Apache configuration..."
sudo apachectl configtest

echo "==> Restarting Apache..."
sudo systemctl restart $HTTPD_SERVICE

echo "==> mod_evasive updated successfully."

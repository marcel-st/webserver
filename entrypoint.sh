#!/bin/bash
set -e

echo "Updating packages to latest versions..."
apt-get update -qq && apt-get upgrade -y -qq
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Starting Apache HTTP Server..."
# Run Apache in the foreground
exec apache2ctl -D FOREGROUND

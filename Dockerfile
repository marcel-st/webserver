FROM ubuntu:24.04

LABEL maintainer="webserver"
LABEL description="Apache HTTP Server on Ubuntu 24.04 LTS"

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Apache, PHP, and supporting packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apache2 \
        libapache2-mod-php \
        php \
        php-cli \
        apt-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable required Apache modules
RUN a2enmod rewrite headers ssl

# Set global ServerName to suppress FQDN warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Copy Apache virtual host configuration
COPY config/000-default.conf /etc/apache2/sites-available/000-default.conf

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create web root directory and set permissions
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Expose HTTP port
EXPOSE 80

# Use entrypoint to apply updates on each deployment
ENTRYPOINT ["/entrypoint.sh"]

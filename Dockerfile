FROM opensuse/tumbleweed

# Environment variables
ENV BACKDROP_VERSION=1.27.1
ENV BACKDROP_URL=https://github.com/backdrop/backdrop/releases/download/$BACKDROP_VERSION/backdrop.zip
ENV BACKDROP_DIR=/srv/www/htdocs

ENV SITE_URL=www.orians.org
ENV SITE_ALIAS_URL=orians.org

# Install Apache, PHP, and dependencies
RUN zypper --non-interactive ref
RUN zypper --non-interactive install apache2 apache2-utils
RUN zypper --non-interactive install php8
RUN zypper --non-interactive install php8-APCu php8-cli php8-ctype php8-curl php8-dom php8-fileinfo php8-gd php8-gettext php8-iconv php8-intl php8-mbstring php8-mysql php8-openssl php8-pdo php8-pear php8-phar php8-posix php8-sqlite php8-sysvsem php8-tokenizer php8-xmlreader php8-xmlwriter php8-zip php8-zlib
RUN zypper --non-interactive install apache2-mod_php8
RUN zypper --non-interactive install wget
RUN zypper --non-interactive install tar
RUN zypper --non-interactive install unzip 
RUN zypper --non-interactive install vim

# Enable Apache PHP module
RUN a2enmod php8

# Download and install Backdrop
RUN cd /tmp && \
    wget $BACKDROP_URL && \
    unzip backdrop.zip && \
    mv backdrop/* $BACKDROP_DIR && \
    rm -rf backdrop backdrop.zip

# Set directory permissions
RUN chown -R wwwrun:www $BACKDROP_DIR
RUN chmod -R 755 $BACKDROP_DIR

# Setup VirtualHost for subdomain
RUN echo "<VirtualHost *:80>" > /etc/apache2/vhosts.d/backdrop.conf && \
    echo "    ServerName $SITE_URL" >> /etc/apache2/vhosts.d/backdrop.conf && \
    echo "    ServerAlias $SITE_ALIAS_URL" >> /etc/apache2/vhosts.d/backdrop.conf && \
    echo "    DocumentRoot \"$BACKDROP_DIR\"" >> /etc/apache2/vhosts.d/backdrop.conf && \
    echo "    <Directory \"$BACKDROP_DIR\">" >> /etc/apache2/vhosts.d/backdrop.conf && \
    echo "        Options All" >> /etc/apache2/vhosts.d/backdrop.conf && \
    echo "        AllowOverride All" >> /etc/apache2/vhosts.d/backdrop.conf && \
    echo "    </Directory>" >> /etc/apache2/vhosts.d/backdrop.conf && \
    echo "    ErrorLog /var/log/apache2/backdrop-error.log" >> /etc/apache2/vhosts.d/backdrop.conf && \
    echo "    CustomLog /var/log/apache2/backdrop-access.log combined" >> /etc/apache2/vhosts.d/backdrop.conf && \
    echo "</VirtualHost>" >> /etc/apache2/vhosts.d/backdrop.conf

# Expose HTTP port
EXPOSE 80

CMD ["/usr/sbin/start_apache2", "-DFOREGROUND"]


FROM uqlibrary/docker-base:12

RUN rpm -Uvh http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm

RUN \
  yum install -y \
    php56u-common \
    php56u-fpm \
    php56u-gd \
    php56u-imap \
    php56u-ldap \
    php56u-mcrypt \
    php56u-mysqlnd \
    php56u-pdo \
    php56u-pecl-geoip \
    php56u-pecl-memcached \
    php56u-pecl-redis \
    php56u-pecl-xdebug \
    php56u-pgsql \
    php56u-sqlite \
    php56u-soap \
    php56u-xmlrpc \
    php56u-mbstring \
    php56u-tidy \
    php56u-opcache \
    git \
    newrelic-php5 \
    newrelic-sysmond && \
  yum clean all

COPY etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf
COPY etc/php.d/15-xdebug.ini /etc/php.d/15-xdebug.ini

RUN rm -f /etc/php.d/20-mssql.ini && \
    rm -f /etc/php.d/30-pdo_dblib.ini && \
    sed -i "s/;date.timezone =.*/date.timezone = Australia\/Brisbane/" /etc/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php.ini && \
    sed -i "s/display_errors =.*/display_errors = Off/" /etc/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 30M/" /etc/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php-fpm.conf && \
    sed -i "s/error_log =.*/error_log = \/proc\/self\/fd\/2/" /etc/php-fpm.conf && \
    usermod -u 1000 nobody

EXPOSE 9000

ENV NSS_SDB_USE_CACHE YES

ENTRYPOINT ["/usr/sbin/php-fpm", "--nodaemonize"]

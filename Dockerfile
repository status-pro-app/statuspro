FROM nginx

RUN rm -f /etc/nginx/conf.d/*


RUN apt-get update && apt-get install -my \
  supervisor \
  curl \
  wget \
  php5-curl \
  php5-fpm \
  php5-gd \
  php5-memcached \
  php5-mysql \
  php5-mcrypt \
  php5-sqlite \
  php5-xdebug \
  php-apc \
  php5-intl \
  php5-cli 

RUN sed -i "s/user = www-data/user = root/" /etc/php5/fpm/pool.d/www.conf
RUN sed -i "s/group = www-data/group = root/" /etc/php5/fpm/pool.d/www.conf

RUN sed -i '/^;clear_env = no/s/^;//' /etc/php5/fpm/pool.d/www.conf

RUN sed -i '/^;ping\.path/s/^;//' /etc/php5/fpm/pool.d/www.conf
RUN sed -i '/^;pm\.status_path/s/^;//' /etc/php5/fpm/pool.d/www.conf
RUN sed -i '/.*xdebug.so$/s/^/;/' /etc/php5/mods-available/xdebug.ini

COPY conf/nginx.conf /etc/nginx/
COPY conf/supervisord.conf /etc/supervisor/conf.d/
COPY conf/php.ini /etc/php5/fpm/conf.d/40-custom.ini


VOLUME ["/var/www", "/etc/nginx/conf.d"]


EXPOSE 80 443 9000

ENTRYPOINT ["/usr/bin/supervisord"]

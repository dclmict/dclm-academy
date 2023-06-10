FROM opeoniye/php81

RUN apt-get update && apt-get install -y cron 

# php log
RUN mkdir /var/log/php && \
  touch /var/log/php/errors.log && chmod 777 /var/log/php/errors.log

# copy configs
COPY ./ops/docker/run.sh /var/docker/run.sh
COPY ./ops/docker/supervisor.conf /etc/supervisord.conf
COPY ./ops/docker/php/php.ini /usr/local/etc/php/conf.d/app.ini
COPY ./ops/docker/php/fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./ops/docker/ngx/nginx.conf /etc/nginx/nginx.conf
COPY ./ops/docker/ngx/academy.conf /etc/nginx/sites-enabled/default
COPY ./ops/docker/ngx/ssl.conf /etc/nginx/ssl.conf
COPY ./ops/docker/ngx/proxy /etc/nginx/proxy_params
COPY ./ops/docker/ngx/exploit.conf /etc/nginx/snippets/exploit_protection.conf
COPY ./ops/docker/ngx/optimize.conf /etc/nginx/snippets/site_optimization.conf
COPY ./ops/docker/ngx/log.conf /etc/nginx/snippets/logging.conf

# copy code
# COPY --chown=www-data:www-data ./src /var/www

# working directory
WORKDIR /var/www

## deployment
RUN  usermod -a -G www-data root && \
  chown -R www-data:www-data . && \
  find . -type d -exec chmod 2775 {} \; && \
  find . -type f -exec chmod 0664 {} \; && \
  chmod +x /var/docker/run.sh

# Add the cron job
RUN crontab -l | { cat; echo "* * * * * /usr/local/bin/php /var/www/admin/cli/cron.php >/dev/null"; } | crontab -

EXPOSE 80
ENTRYPOINT ["/var/docker/run.sh"]
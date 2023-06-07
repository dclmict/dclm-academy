FROM opeoniye/php74:latest

# copy configs
COPY ./ops/docker/run.sh /var/docker/run.sh
COPY ./ops/docker/supervisor.conf /etc/supervisord.conf
COPY ./ops/docker/php/php.ini /usr/local/etc/php/conf.d/app.ini
COPY ./ops/docker/ngx/nginx.conf /etc/nginx/nginx.conf
COPY ./ops/docker/ngx/lsc.conf /etc/nginx/sites-enabled/default
COPY ./ops/docker/ngx/ssl.conf /etc/nginx/ssl.conf
COPY ./ops/docker/ngx/proxy /etc/nginx/proxy_params
COPY ./ops/docker/ngx/exploit.conf /etc/nginx/snippets/exploit_protection.conf
COPY ./ops/docker/ngx/optimize.conf /etc/nginx/snippets/site_optimization.conf
COPY ./ops/docker/ngx/log.conf /etc/nginx/snippets/logging.conf

# php log files
RUN mkdir /var/log/php && \
  touch /var/log/php/errors.log && chmod 777 /var/log/php/errors.log

# copy code
# COPY --chown=www:www-data ./src /var/www

# working directory
WORKDIR /var/www

## deployment
RUN  usermod -a -G www-data root && \
  chown -R www-data:www-data . && \
  find . -type d -exec chmod 2775 {} \; && \
  find . -type f -exec chmod 0664 {} \; && \
  chmod +x /var/docker/run.sh

EXPOSE 80
ENTRYPOINT ["/var/docker/run.sh"]
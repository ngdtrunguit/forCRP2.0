FROM nginx:alpine
RUN chmod g+rwx /var/cache/nginx/ /var/run /var/log/nginx
COPY src/html /var/www/
COPY src/nginx.conf /etc/nginx/nginx.conf
EXPOSE 8000
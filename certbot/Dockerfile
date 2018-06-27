FROM certbot/certbot:v0.25.1
RUN echo '0 6 1,16 * * date && certbot renew --agree-tos' > /var/spool/cron/crontabs/root
ENTRYPOINT [ "/usr/sbin/crond", "-f", "-d", "6" ]

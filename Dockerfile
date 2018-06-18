FROM vasyharan/nginx:1.13.3-alpine

COPY server.conf /etc/nginx/servers/default.conf
COPY dist /usr/share/nginx/html

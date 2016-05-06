FROM vasyharan/nginx:latest

COPY server.conf /etc/nginx/servers/default.conf
COPY dist /usr/share/nginx/html

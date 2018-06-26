FROM nginx:1.15.0-alpine

RUN mkdir -p /etc/nginx/servers
COPY nginx/ /etc/nginx/
COPY dist/ /static/
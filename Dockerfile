FROM nginx:alpine

COPY visit_nepal2027.html /usr/share/nginx/html/index.html
COPY images/ /usr/share/nginx/html/images/

EXPOSE 80
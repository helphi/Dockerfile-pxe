FROM nginx:1.10-alpine

RUN apk add --no-cache tftp-hpa dhcp 

RUN sed -i "s#/usr/share/nginx/html;#/pxe/nginx;#g" /etc/nginx/conf.d/default.conf

ADD start.sh /root/start.sh

VOLUME /pxe

EXPOSE 67 69 80 

CMD ["sh", "/root/start.sh"]


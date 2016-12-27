FROM nginx:1.10-alpine

RUN apk add --no-cache tftp-hpa dhcp nfs-utils

RUN sed -i "s#/usr/share/nginx/html;#/pxe/nginx;#g" /etc/nginx/conf.d/default.conf
RUN echo "/pxe/nfs *(rw,fsid=0,root_squash,no_subtree_check,insecure)" >> /etc/exports

ADD start.sh /root/start.sh

VOLUME /pxe

EXPOSE 67 69 111 2049

CMD ["sh", "/root/start.sh"]


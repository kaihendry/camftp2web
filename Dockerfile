FROM alpine:latest

MAINTAINER Kai Hendry <hendry@iki.fi>

RUN apk upgrade --update --available && \
    apk add \
      ffmpeg \
      lighttpd \
      lighttpd-mod_auth \
      vsftpd \
      bash \
      inotify-tools \
      supervisor \
    && rm -f /var/cache/apk/*

EXPOSE 21 80

RUN mkdir -pm 0711 /var/empty/vsftpd
ADD vsftpd.conf /etc/vsftpd/vsftpd.conf

# docker cp ftp:/etc/lighttpd/lighttpd.conf .
ADD lighttpd.conf /etc/lighttpd/lighttpd.conf
ADD move.sh /bin/

ADD supervisor.d /etc/supervisor.d/

# Ftp account(s)
RUN adduser -D user && echo 'user:passwd' | chpasswd
# Web access account
ADD users.txt /var/www/

CMD supervisord -n -c /etc/supervisord.conf

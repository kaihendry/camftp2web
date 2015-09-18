FROM alpine:latest

MAINTAINER Kai Hendry <hendry@iki.fi>

RUN apk upgrade --update --available && \
    apk add \
      ffmpeg \
      vsftpd \
      bash \
      inotify-tools \
    && rm -f /var/cache/apk/*

EXPOSE 21

RUN mkdir -pm 0711 /var/empty/vsftpd
ADD vsftpd.conf /etc/vsftpd/vsftpd.conf

ADD move.sh /bin/

VOLUME /etc/ftp-users.txt
VOLUME /var/www/cam

ADD start.sh /start.sh
CMD /start.sh

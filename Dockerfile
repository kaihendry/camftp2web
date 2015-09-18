FROM alpine:latest

MAINTAINER Kai Hendry <hendry@iki.fi>

RUN apk upgrade --update --available && \
    apk add \
      ffmpeg \
      vsftpd \
      bash \
      inotify-tools \
      supervisor \
    && rm -f /var/cache/apk/*

EXPOSE 21

RUN mkdir -pm 0711 /var/empty/vsftpd
ADD vsftpd.conf /etc/vsftpd/vsftpd.conf
# Setup FTP users
COPY ftp-users.txt /etc/ftp-users.txt
RUN while read -r user; do adduser -D "${user%%:*}" && echo "$user" | chpasswd; done < /etc/ftp-users.txt

# FFMPEG
ADD move.sh /bin/

ADD supervisor.d /etc/supervisor.d/

VOLUME /home/
VOLUME /var/www/cam

CMD supervisord -n -c /etc/supervisord.conf

FROM alpine:latest

MAINTAINER Kai Hendry <hendry@iki.fi>

# Install dependencies.
RUN apk upgrade --update --available && \
    apk add \
      vsftpd \
    && rm -f /var/cache/apk/*

EXPOSE 21/tcp
ENV LANG C

# Configure vsftpd.
ADD start.sh /start.sh

RUN mkdir -pm 0711 /var/empty/vsftpd

# https://github.com/mikz/dockerfiles/blob/master/vsftpd/vsftpd.sh
# RUN adduser -D 888

VOLUME ["/home"]

ADD vsftpd.conf /etc/vsftpd/vsftpd.conf

CMD /start.sh

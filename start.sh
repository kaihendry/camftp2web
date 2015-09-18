#!/bin/sh

# Setup FTP users
while read -r user; do adduser -D "${user%%:*}" && echo "$user" | chpasswd; done < /etc/ftp-users.txt

readonly logfile=/var/log/vsftpd.log
tail -F $logfile &
/bin/move.sh &
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf

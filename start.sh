#!/bin/sh

readonly logfile=/var/log/vsftpd.log
tail -F $logfile &
/bin/move.sh &
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf

#!/bin/sh

readonly logfile=/var/log/vsftpd.log
tail -F $logfile &
touch $logfile
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf

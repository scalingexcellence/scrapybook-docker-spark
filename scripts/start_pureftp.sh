#!/bin/sh
# Pureftp service

#exec /usr/sbin/pure-ftpd -l pam -e -p 30000:30009 -u 1000 -8 UTF-8 -O clf:/var/log/pure-ftpd/transfer.log -B
exec /etc/init.d/pure-ftpd


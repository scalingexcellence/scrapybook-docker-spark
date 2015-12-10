#!/bin/sh
# uploadscript service

# runit will automatically retry
if [[ ! -f /var/run/pure-ftpd.upload.pipe ]] ; then
    exit -1
fi

# Cleanup
rm -f /root/items/* /home/ftp/*

exec /usr/sbin/pure-uploadscript -r /opt/pure-ftpd/on_upload.sh

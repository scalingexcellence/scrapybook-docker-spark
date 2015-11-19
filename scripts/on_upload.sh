#!/bin/bash

ftp_file="$1"
ftp_file_name=$(basename "$ftp_file")
ftp_file_dest="/root/items/$ftp_file_name"

ln -fs "$ftp_file" "$ftp_file_dest"

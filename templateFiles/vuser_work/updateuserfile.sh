#!/bin/bash

infile="/etc/vsftpd/vconf/vuser_work/vu.txt"
if [[ -n $1 ]];then
    infile=$1
    fi
rm -f /etc/vsftpd/vusers.db
db_load -T -t hash -f $infile /etc/vsftpd/vusers.db
unset infile

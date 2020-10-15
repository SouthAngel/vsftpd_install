#!/bin/bash
if [[ ! $# -eq 2 ]];then
    echo "Usage: ./adduser.sh [username] [password]"
    exit 1
    fi
echo "$1" > ./tmpvu
echo "$2" >> ./tmpvu
db_load -T -t hash -f ./tmpvu /etc/vsftpd/vusers.db
rm -f ./tmpvu


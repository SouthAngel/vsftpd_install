#!/bin/bash

bakeorgfile(){
    local tbfiles=("/etc/vsftpd/vsftpd.conf", "/etc/shells")
    for eachf in "${tbfiles[@]}";do
        local bfile="${eachf}.bake"
        if [ ! -e bfile ]; then
            cp $eachf $bfile
            fi
        done
}

_main(){

local cmdo=''

if [ -z `yum info vsftpd | grep "installed"` ];then
    cmdo=`yum install -y vsftpd`
    echo $cmdo
    fi


bakeorgfile

# 准备本地用户
local stmp=`grep "/sbin/nologin" /etc/shells`
if [ -z "$stmp" ]; then
    echo "/sbin/nologin" >> /etc/shells
    fi
stmp=`grep "^ftpvirtualuser" /etc/passwd`
if [ -z "$stmp" ]; then
    useradd -d /opt/ftproot -s /sbin/nologin ftpvirtualuser
    fi

# 拷贝配置文件
cmdo=`cp -f ./templates/vsftpd.conf /etc/vsftpd/vsftpd.conf`

# 配置虚拟用户
cmdo=`mkdir /etc/vsftpd/vconf`
if [ ! -e "/etc/vsftpd/vconf" ]; then
    cmdo=`cp -R ./templates/vuser_work /etc/vsftpd/vconf/vuser_work`
    echo $cmdo
    fi
cmdo=`db_load -T -t hash -f /etc/vsftpd/vconf/vuser_work/vu.txt /etc/vsftpd/vusers.db`
echo $cmdo
echo "auth required pam_userdb.so db=/etc/vsftpd/vusers" > /etc/pam.d/vsftpd.vusers
echo "account required pam_userdb.so db=/etc/vsftpd/vusers" >> /etc/pam.d/vsftpd.vusers

# 配置防火墙
firewall-cmd --zone=public --add-protocol=ftp --permanent &&
firewall-cmd --zone=public --add-port=20-21/tcp --permanent &&
firewall-cmd --reload

# 重启vsftpd服务
systemctl restart vsftpd

}


_main
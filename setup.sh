#!/bin/bash

bakeorgfile(){
    local tbfiles=("/etc/vsftpd/vsftpd.conf" "/etc/shells")
    for eachf in "${tbfiles[@]}";do
        local bfile="${eachf}.bake"
        if [ ! -e bfile ]; then
            cp $eachf $bfile
            fi
        done
}

_main(){

if [[ -z `yum info vsftpd | grep "installed"` ]];then
    yum install -y vsftpd
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
    chmod 755 /opt/ftproot
    fi
sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0

# 拷贝配置文件
cp -f ./templateFiles/vsftpd.conf /etc/vsftpd/vsftpd.conf
echo "vftptest1" > /etc/vsftpd/chroot_list

# 配置虚拟用户
if [ ! -e "/etc/vsftpd/vconf" ]; then
    mkdir /etc/vsftpd/vconf
    cp -R ./templateFiles/vuser_work /etc/vsftpd/vconf
    cp ./templateFiles/vuser_work/user_template /etc/vsftpd/vconf/vftptest1
    cp ./templateFiles/vuser_work/user_template /etc/vsftpd/vconf/vftptest2
    fi
db_load -T -t hash -f /etc/vsftpd/vconf/vuser_work/vu.txt /etc/vsftpd/vusers.db
echo "auth required pam_userdb.so db=/etc/vsftpd/vusers" > /etc/pam.d/vsftpd.vusers
echo "account required pam_userdb.so db=/etc/vsftpd/vusers" >> /etc/pam.d/vsftpd.vusers

# 配置防火墙
# firewall-cmd --zone=public --add-protocol=ftp --permanent &&
firewall-cmd --zone=public --add-port=20-21/tcp --permanent &&
firewall-cmd --zone=public --add-port=30000-30999/tcp --permanent &&
firewall-cmd --reload

# 重启vsftpd服务
systemctl enable vsftpd
systemctl restart vsftpd

}


_main
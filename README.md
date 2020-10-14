# vsftpd_install
vsftpd服务安装过程

----
## Env
- Centos 7

----
## 脚本安装
```sh
# 
yum install git 
git clone https://github.com/SouthAngel/vsftpd_install.git
cd vsftpd_install
chmod +x setup.sh
./setup.sh
```

----
## 遇到的问题
- 设置 -s /sbin/nologin 用户后，客户端无法登录  
&nbsp;&nbsp;&nbsp;&nbsp; /etc/shells 文件追加行 /sbin/nologin
- 客户端可以登录，但无法进行其他动作，报错 425 failed to establish connection  
&nbsp;&nbsp;&nbsp;&nbsp; 需要设置selinux关闭，具体操作设置 /etc/selinux/config SELINUX=disable

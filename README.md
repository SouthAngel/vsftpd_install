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
## 自动化过程

----
## 自动化过程

----
## 遇到的问题
- 设置 -s /sbin/nologin 用户后，客户端无法登录  
&nbsp;&nbsp;&nbsp;&nbsp; /etc/shells 文件追加行 /sbin/nologin

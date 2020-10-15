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
sudo chmod +x setup.sh
sudo ./setup.sh
```

----
## 配置文件说明
#### 配置文件地址
- /etc/vsftpd/vsftpd.conf
- /etc/vsftpd/vconf/[username]

设置 | 描述 | 内容
-|-|-
anonymous_enable | 允许匿名用户 | YES/NO
ftp_username | 匿名登录时使用的默认用户 | 指定用户名
no_anon_password | 允许匿名用户不使用密码 | YES/NO
anon_upload_enable | 允许匿名用户上传 | YES/NO
anon_mkdir_write_enable | 允许匿名用户创建文件夹 | YES/NO
anon_world_readable_only | 仅允许匿名用户通过ftp客户端查看，不允许下载 | YES/NO
local_enable | 允许本地用户 | YES/NO
write_enable | 开放写权限 | YES/NO
local_umask | 上传内容的初始权限 | 参考系统umask设置
userlist_enable | 使用用户限制名单 | YES/NO
userlist_deny | 限制名单为黑名单，否则为白名单 | YES/NO
userlist_file | 限制文件路径 | 文件路径
chroot_local_user | 开启访问限制，不允许访问指定根目录以外的路径 | YES/NO
chroot_list_enable | 使用访问限制列表 | YES/NO
chroot_list_file | 访问限制列表文件路径 | 文件路径
local_root | 指定根目录 | 文件夹路径

----
## 遇到的问题
- 设置 -s /sbin/nologin 用户后，客户端无法登录  
&nbsp;&nbsp;&nbsp;&nbsp; /etc/shells 文件追加行 /sbin/nologin
- 客户端可以登录，但无法进行其他动作，报错 425 failed to establish connection  
&nbsp;&nbsp;&nbsp;&nbsp; 需要设置selinux关闭，具体操作设置 /etc/selinux/config SELINUX=disable
- 报错 500 OOPS: vsftpd: refusing to run with writable root inside chroot()  
&nbsp;&nbsp;&nbsp;&nbsp; 主目录权限问题，主目录需要拥有可执行权限，如果设置了chroot，还要要求主目录不能有写权限


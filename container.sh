#!/bin/bash

#DO NOT EXECUTE OUTSIDE OF CONTAINER

# config

. /home/config.txt

#Upgrade if we used tar for building container

if [ $1 = "-a" ]
then
#I LOVE CANDY
#echo ILoveCandy >> /etc/pacman.conf
http_proxy=$http_proxy https_proxy=$https_proxy pacman -Syu --noconfirm
http_proxy=$http_proxy https_proxy=$https_proxy pacman -S $pkg --needed --noconfirm
fi

#create user

chmod 755 /
useradd $user
echo "$user:$password"| chpasswd
echo "root:$password"| chpasswd
echo "arch ALL=(ALL) ALL" >> /etc/sudoers
echo "Defaults:arch !env_reset"
chown $user /opt
mkdir /home/$user
chown $user /home/$user

#Build nginx-rtmp in userspace shell

http_proxy=$http_proxy https_proxy=$https_proxy su - $user << EOF
pwd

#clone

cd /opt
http_proxy=$http_proxy https_proxy=$https_proxy git clone https://aur.archlinux.org/nginx-rtmp.git
cd nginx-rtmp
http_proxy=$http_proxy https_proxy=$https_proxy makepkg -si --noconfirm

EOF

#copy&create misc files&dirs

mkdir /var/www
mv /home/nginx.conf /etc/nginx/nginx.conf

#enable services

systemctl enable nginx
systemctl enable dropbear
exit

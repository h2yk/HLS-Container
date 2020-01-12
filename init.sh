#!/bin/bash

#conf

. config.txt
echo $archdir > .gitignore
echo tmp.tar.gz >> .gitignore

#root chk

if [ ${EUID:-${UID}} != 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

#init

mkdir $archdir

#use tar(other distros) or pacstrap(archlinux)

if [ $1 = "-a" ]
then
#wget $url -O tmp.tar.xz
tar xvf tmp.tar.xz -C $archdir
else
http_proxy=$http_proxy https_proxy=$https_proxy pacstrap -i -c -d $archdir $pkg --ignore linux --noconfirm
fi

#copy needed files into container

cp container.sh ${archdir}/home
cp config.txt ${archdir}/home
cp nginx.conf ${archdir}/home

#start container script

systemd-nspawn -D arch /home/container.sh $1

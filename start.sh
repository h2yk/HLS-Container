#!/bin/bash

#conf

. config.txt

#root chk

if [ ${EUID:-${UID}} != 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

#boot container

systemd-nspawn -bD $archdir

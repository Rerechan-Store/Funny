#!/bin/bash
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project | • FN Project 
#  Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian | 
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] 
#  | [ 上海，中国 ] | 
#  |=================================================================================|
#
cd
apt install sslh -y
rm -fr /usr/sbin/sslh
wget -O /usr/sbin/sslh "https://raw.githubusercontent.com/Rerechan-Store/Funny/main/sslh"
chmod +x /usr/sbin/sslh
rm -fr /etc/default/sslh
wget -O /etc/default/sslh "https://raw.githubusercontent.com/Rerechan-Store/Funny/main/sslh.conf"
chmod +x /etc/default/sslh
systemctl daemon-reload
systemctl restart sslh
clear
cd
rm -fr sslh.sh
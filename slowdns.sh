#!/bin/bash
clear
apt install screen -y
rm -fr /etc/slowdns
mkdir -p /etc/slowdns
cd /etc/slowdns
clear
echo -e "
═══════════════════════════
Slowdns DNS-TT Server
Please input valid nameserver
═══════════════════════════
"
read -p "Nameserver: " nsdomain
echo $nsdomain >/etc/slowdns/nsdomain
clear
cd /etc/slowdns
wget -O /usr/bin/dnstt-server "https://raw.githubusercontent.com/Rerechan-Store/Funny/main/dns-server"
chmod +x /usr/bin/dnstt-server
dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub
screen -dmS slowdns ./dnstt-server -udp :5300 -privkey-file server.key $nsdomain 127.0.0.1:109
cd
clear
rm -fr slowdns.sh
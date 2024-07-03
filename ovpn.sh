#!/bin/bash
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project | • FN Project 
#  Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian | 
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] 
#  | [ 上海，中国 ] | 
#  |=================================================================================|
#
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(curl -s ifconfig.me);
MYIP2="s/xxxxxxxxx/$MYIP/g";

function ovpn_install() {
    rm -rf /etc/openvpn
    mkdir -p /etc/openvpn
    wget -O /etc/openvpn/vpn.zip "https://raw.githubusercontent.com/praiman99/Certificate-Openvpn-Mod/Beginner/vpn.zip" >/dev/null 2>&1 
    unzip -d /etc/openvpn/ /etc/openvpn/vpn.zip
    rm -f /etc/openvpn/vpn.zip
    chown -R root:root /etc/openvpn/server/easy-rsa/
}
function config_easy() {
cp /etc/openvpn/server/ca.crt /etc/openvpn/ca.crt
cp /etc/openvpn/server/dh2048.pem /etc/openvpn/dh2048.pem
cp /etc/openvpn/server/dh.pem /etc/openvpn/dh.pem
cp /etc/openvpn/server/server.crt /etc/openvpn/server.crt
cp /etc/openvpn/server/server.key /etc/openvpn/server.key
chmod +x /etc/openvpn/ca.crt
    cd
    mkdir -p /usr/lib/openvpn/
    cp /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so /usr/lib/openvpn/openvpn-plugin-auth-pam.so
    sed -i 's/#AUTOSTART="all"/AUTOSTART="all"/g' /etc/default/openvpn
    systemctl enable --now openvpn-server@server-tcp
    systemctl enable --now openvpn-server@server-udp
    /etc/init.d/openvpn restart
}

function make_follow() {
    echo 1 > /proc/sys/net/ipv4/ip_forward
    sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
    echo 1 > /proc/sys/net/ipv6/ip_forward
    sed -i 's/#net.ipv6.ip_forward=1/net.ipv6.ip_forward=1/g' /etc/sysctl.conf
cat > /etc/openvpn/tcp.ovpn <<-END
client
dev tun
proto tcp
remote xxxxxxxxx 1194
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END
    
    sed -i $MYIP2 /etc/openvpn/tcp.ovpn;
cat > /etc/openvpn/udp.ovpn <<-END
client
dev tun
proto udp
remote xxxxxxxxx 2200
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END
    
    sed -i $MYIP2 /etc/openvpn/udp.ovpn;
}

function cert_ovpn() {
    echo '<ca>' >> /etc/openvpn/tcp.ovpn
    cat /etc/openvpn/server/ca.crt >> /etc/openvpn/tcp.ovpn
    echo '</ca>' >> /etc/openvpn/tcp.ovpn
    cp /etc/openvpn/tcp.ovpn /var/www/html/tcp.ovpn
    echo '<ca>' >> /etc/openvpn/udp.ovpn
    cat /etc/openvpn/server/ca.crt >> /etc/openvpn/udp.ovpn
    echo '</ca>' >> /etc/openvpn/udp.ovpn
    cp /etc/openvpn/udp.ovpn /var/www/html/udp.ovpn
    }

function install_ovpn() {
    ovpn_install
    config_easy
    make_follow
    make_follow
    cert_ovpn
    systemctl enable openvpn
    systemctl start openvpn
    /etc/init.d/openvpn restart
    cd
    rm -fr ovpn.sh

}
install_ovpn
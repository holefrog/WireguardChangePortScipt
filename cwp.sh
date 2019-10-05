#!/bin/bash
rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))  
}
wireguard_changeport(){
	clear

	cd /etc/wireguard

	port=$(rand 10000 60000)

	echo "**********************************"
	echo          new port is: $port
	echo "**********************************"

    sudo sed -ri "s|^.*ListenPort = .*$|ListenPort = $port|" wg0.conf
	sudo sed -ri "s|(^.*Endpoint.*\>:).*|\1$port|" client.conf
	sudo sed -ri "s|(^.*Endpoint.*\>:).*|\1$port|" client0.conf
}
sudo wg-quick down wg0
wireguard_changeport
sudo wg-quick up wg0
sudo wg
sudo qrencode -t ansiutf8 < /etc/wireguard/client.conf
sudo qrencode -t ansiutf8 < /etc/wireguard/client0.conf
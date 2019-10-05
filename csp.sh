#!/bin/bash
rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))  
}
ss_changeport(){
	clear
	
	port=$(rand 10000 60000)
	
	echo "**********************************"
	echo          new port is: $port
	echo "**********************************"

	sudo sed -ri 's|(^.*port":)[^,]*|\1MyPort|' /opt/outline/persisted-state/shadowbox_config.json
	sudo sed -ri "s|MyPort|$port|" /opt/outline/persisted-state/shadowbox_config.json
	
	sudo sed -ri 's|(^.*portForNewAccessKeys":)[^}]*|\1MyPort|' /opt/outline/persisted-state/shadowbox_server_config.json
	sudo sed -ri "s|MyPort|$port|" /opt/outline/persisted-state/shadowbox_server_config.json
}

ss_changeport
 
sudo docker restart shadowbox

sudo netstat -tunlp |grep outline-ss-ser


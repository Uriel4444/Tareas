#!/bin/bash

read -p "Introduce la direccion IP o el rango de IPs a escanear: " ip_range

read -p "Introduce la direccion IP o el rango de puertos  a escanear (por ejemplo, 1-1000): " port_range

echo "Escaneando puertos con nmap..."
nmap -p $port_range $ip_range -oG - | grep "/open" > nmap_results.txt

echo "Verificando puertos abiertos con netcat..."
while read -r line; do
	ip=$(echo $line | awk '{print $2}')
	ports=$(echo $line | grep -oP '\d+/open' | cut -d '/' -f 1)
	for port in $ports; do
		nc -zv $ip $port 2>&1 | grep -q "open" && echo "Puerto $port en $ip esta abierto"
	done
done < nmap_results.txt

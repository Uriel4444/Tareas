#!/bin/bash

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

check_cpu(){
	cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
	echo "Uso del CPU: $cpu_usage %"
	if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
		echo "ALERTA: Uso del CPU por encima del $CPU_THRESHOLD %!"
	fi
}

check_memory(){
	memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
	echo "Uso de la memoria: $memory_usage %"
	if (( $(echo "$memory_usage > $MEMORY_THRESHOLD" | bc -l) )); then
		echo "ALERTA: Uso de la Memoria por encima del $MEMORY_THRESHOLD %!"
	fi
}

check_disk(){
	disk_usage=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
	echo "Uso del disco: $disk_usage %"
	if [ $disk_usage -gt $DISK_THRESHOLD ]; then
		echo "ALERTA: Uso del disco por encima del DISK_THRESHOLD %!"
	fi
}

check_vmstat(){
	vmstat 1 5
}

check_iostat(){
	iostat -dx 1 5
}

check_cpu
check_memory
check_disk
check_vmstat
check_iostat

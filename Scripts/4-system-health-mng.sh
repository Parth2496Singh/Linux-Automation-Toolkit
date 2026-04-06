#!/bin/bash
#
set -euo pipefail
LOG_FILE="/home/ubuntu/Linux-Automation-Toolkit/Logs/Automation.log"
mkdir -p "(dirname $LOG_FILE)"
[ -f $LOG_FILE ] | touch $LOG_FILE

disk_usage(){
	echo "Checking disk usage..."
	if ! df -h ; then
	echo "Warning"
	else 
		echo "Storage okay"
	fi
}
disk_usage

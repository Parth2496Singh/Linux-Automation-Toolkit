#!/bin/bash
#
set -euo pipefail
LOG_FILE="/home/ubuntu/Linux-Automation-Toolkit/Logs/Automation.log"
mkdir -p "$(dirname "$LOG_FILE")"
[ -f "$LOG_FILE" ] || touch "$LOG_FILE"
create_user(){
	local username="$1"

	if [ -z "$username" ]; then
		echo "$(date)-ERROR: No username provided for creating user" >>"$LOG_FILE"
		echo "Usage: $0 create_user <username>"
		return 1
	fi

	if id "$username" &>/dev/null; then
        	echo "$(date)-ERROR: Username $username already exists." >>"$LOG_FILE"
        	return 1
        fi

	echo "Creating new user..."

	if sudo useradd "$username"; then
		echo "$(date)- Username Created successfully: $username" >>"$LOG_FILE"
	else
		echo "$(date)-ERROR: Username creation unsuccessful: $username" >>"$LOG_FILE"
		return 1
	fi

}
delete_user(){
	local username="$1"

        if [ -z "$username" ]; then
                echo "$(date)-ERROR: No username provided for deleting user" >>"$LOG_FILE"
                echo "Usage: $0 delete_user <username>"
                return 1
        fi
	
	if ! id "$username" &>/dev/null; then
		echo "$(date)-ERROR: User $username does not exist." >>"$LOG_FILE"
		return 1
	fi


	echo "Deleting user..."
	if sudo userdel "$username"; then
                echo "$(date)- Username Deleted successfully: $username" >>"$LOG_FILE"
        else
                echo "$(date)-ERROR: Username deletion unsuccessful: $username" >>"$LOG_FILE"
                return 1
        fi
}
create_group(){
	local groupname="$1"

        if [ -z "$groupname" ]; then
                echo "$(date)-ERROR: No group name provided for creating group " >>"$LOG_FILE"
                echo "Usage: $0 create_group <groupname>"
                return 1
        fi
	
	if  getent group "$groupname" &>/dev/null ; then
		echo "$(date)-ERROR: Group '$groupname' already exists " >>"$LOG_FILE"
		return 1
	fi

	echo "Creating new group.."

	if sudo groupadd "$groupname" ;then
                echo "$(date)- New group created successfully: $groupname" >>"$LOG_FILE"
        else
                echo "$(date)-ERROR: New group creation unsuccessful: $groupname" >>"$LOG_FILE"
                return 1
        fi
	
}
delete_group(){
	local groupname="$1"

        if [ -z "$groupname" ]; then
                echo "$(date)-ERROR: No group name provided for deleting group " >>"$LOG_FILE"
                echo "Usage: $0 delete_group <groupname>"
                return 1
        fi
	
	if ! getent group "$groupname" &>/dev/null; then
		echo "$(date)-ERROR: Group '$groupname' does not exist" >>"$LOG_FILE"
		return 1
	fi

	echo "Deleting group..."

	if sudo groupdel "$groupname"; then
		echo "$(date)- Group deleted succesfully : '$groupname' " >> "$LOG_FILE"
	else
		echo "$(date)- Error deleting group : '$groupname' " >> "$LOG_FILE"
		return 1
	fi
}

case $1 in
	create_user|delete_user|create_group|delete_group)
		if [ $# -lt 2 ]; then
			echo "$(date)- Invalid Action: Incomeplete command" >>"$LOG_FILE"
			echo "Invalid action: Usage $0 $1 <name>"
			exit 1
		fi
		"$1" "$2"
		;;

	*)
		echo "$(date)- Invalid Action!  No such action exists: '$1'" >> "$LOG_FILE"
		echo "Usage: $0 {create_user| delete_user| create_group| delete_group} <name> "
	        exit 1
		;;
esac	

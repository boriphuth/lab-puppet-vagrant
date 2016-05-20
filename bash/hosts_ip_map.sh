#!/bin/bash

declare -A HostIP
HostIP=( ["master.smb.com"]="192.168.33.10" \
         ["node1.smb.com"]="192.168.33.11")

# Remove old HOST IDENTIFICATION
for node in "${!HostIP[@]}"
do
    ssh-keygen -f "~/.ssh/known_hosts" -R ${HostIP["$node"]}
done

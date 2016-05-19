#!/bin/bash
#declare -A HostIP
#HostIP=( ["master.smb.com"]="192.168.33.10" \
#         ["node1.smb.com"]="192.168.33.11")
. ./hosts_ip_map.sh

node=master.smb.com
ip=${HostIP["$node"]}
private_key=master/.vagrant/machines/default/virtualbox/private_key
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$ip sudo puppet cert --list

ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$ip sudo puppet cert --sign node1.smb.com

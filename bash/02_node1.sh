#!/bin/bash
#declare -A HostIP
#HostIP=( ["master.smb.com"]="192.168.33.10" \
#         ["node1.smb.com"]="192.168.33.11")

. ./hosts_ip_map.sh

node=node1.smb.com
ip=${HostIP["$node"]}
private_key=node1/.vagrant/machines/default/virtualbox/private_key

# start puppet service
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$ip "$(< common.sh);  fun_puppet_enable"
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$ip "$(< common.sh);  fun_puppet_fix_issue_PUP2566"
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$ip service puppet start
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$ip sudo puppet agent --test --server master.smb.com
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$ipa sudo puppet agent --enable

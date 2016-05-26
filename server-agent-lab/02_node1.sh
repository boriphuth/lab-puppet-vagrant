#!/bin/bash
#declare -A HostIP
#HostIP=( ["master.smb.com"]="192.168.33.10" \
#         ["node1.smb.com"]="192.168.33.11")

. ./hosts_ip_map.sh

node=node1.smb.com
ip=${HostIP["$node"]}
private_key=node1/.vagrant/machines/default/virtualbox/private_key

# start puppet service
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$ip \
"sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true;
 sudo /opt/puppetlabs/bin/puppet agent --test --server master.smb.com"

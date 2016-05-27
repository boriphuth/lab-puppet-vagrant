#!/bin/bash

. ./hosts_ip_map.sh

function fun_remove_old_identify(){
    # Remove old HOST IDENTIFICATION
    local FILE="$HOME/.ssh/known_hosts"
    for node in "${!HostIP[@]}"
    do
        if [ -f $FILE ]
        then
          ssh-keygen -f $FILE -R ${HostIP["$node"]}
        fi
    done
}

fun_remove_old_identify

node=master.smb.com
ip=${HostIP["$node"]}
private_key=master/.vagrant/machines/default/virtualbox/private_key

echo "Reset puppet-server memory to 1GB and then restart the service."
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$ip "$(< common.sh); fun_puppet_master_memory"

# restart the service
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$ip sudo service puppetserver restart

# start the service when the node reboot
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$ip sudo /opt/puppetlabs/bin/puppet resource service puppetserver ensure=running enable=true

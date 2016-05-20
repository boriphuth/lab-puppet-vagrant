#!/bin/bash

. ./hosts_ip_map.sh 

function fun_update_hosts(){
    ip=$1   
    username=$2
    private_key=$3

    for node in "${!HostIP[@]}"
    do 
        ssh -o StrictHostKeyChecking=no -i $private_key $username@$ip \
               "$(< common.sh);add_host $node ${HostIP["$node"]}"
    done
}

function fun_remove_old_identify(){
    # Remove old HOST IDENTIFICATION
    for node in "${!HostIP[@]}"
    do
        ssh-keygen -f ~/.ssh/known_hosts -R ${HostIP["$node"]}
    done
}

fun_remove_old_identify
fun_update_hosts 192.168.33.10 vagrant master/.vagrant/machines/default/virtualbox/private_key
fun_update_hosts 192.168.33.11 vagrant node1/.vagrant/machines/default/virtualbox/private_key

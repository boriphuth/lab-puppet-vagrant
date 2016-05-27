#!/bin/bash

. ./hosts_ip_map.sh 

function fun_add_hosts(){
    ip=$1   
    username=$2
    private_key=$3

    for node in "${!HostIP[@]}"
    do 
        ssh -o StrictHostKeyChecking=no -i $private_key $username@$ip \
               "$(< common.sh);add_host $node ${HostIP["$node"]}"
    done
}

fun_add_hosts 192.168.33.10 vagrant master/.vagrant/machines/default/virtualbox/private_key
fun_add_hosts 192.168.33.11 vagrant node1/.vagrant/machines/default/virtualbox/private_key

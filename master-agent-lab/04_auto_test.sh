#!/bin/bash

. ./hosts_ip_map.sh

# copy the test file
TEST_FILE=./auto-test/test_site.pp
master_node=master.smb.com
master_ip=${HostIP["$master_node"]}
private_key=master/.vagrant/machines/default/virtualbox/private_key
scp -i $private_key $TEST_FILE vagrant@$master_ip:~/test_site.pp
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$master_ip sudo cp test_site.pp /etc/puppet/manifests/site.pp


# test deploy
node=node1.smb.com
ip=${HostIP["$node"]}
private_key=node1/.vagrant/machines/default/virtualbox/private_key
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$ip sudo puppet agent --enable
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$ip sudo puppet agent --test --server master.smb.com

# verify
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$ip cat /tmp/temp1.txt

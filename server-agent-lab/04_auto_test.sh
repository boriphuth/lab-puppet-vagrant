#!/bin/bash

. ./hosts_ip_map.sh

# copy the test file puppet server
TEST_FILE=./auto-test/test_site.pp
master_node=master.smb.com
master_ip=${HostIP["$master_node"]}
private_key=master/.vagrant/machines/default/virtualbox/private_key
scp -i $private_key $TEST_FILE vagrant@$master_ip:~/test_site.pp
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$master_ip sudo cp test_site.pp /etc/puppetlabs/code/environments/production/manifests/site.pp


# Run test deploy on agent
node=node1.smb.com
ip=${HostIP["$node"]}
private_key=node1/.vagrant/machines/default/virtualbox/private_key

# sudo /opt/puppetlabs/bin/puppet agent --enable;
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$ip \
 "sudo /opt/puppetlabs/bin/puppet agent --test --server master.smb.com"

# verify
echo "/etc/puppetlabs/code/environments/production/manifests/site.pp"
ssh -o StrictHostKeyChecking=no -i $private_key vagrant@$ip cat /tmp/temp1.txt

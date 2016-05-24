#!/bin/bash

cd master
vagrant up
cd ..

sleep 2

cd node1
vagrant up
cd ..


. ./01_add_host.sh | sed "s/^/[01_add_host.sh] /"
. ./02_node1.sh | sed "s/^/[02_node1.sh] /"
. ./03_master_accept.sh | sed "s/^/[03_master_accept.sh] /"

. ./04_auto_test.sh | sed "s/^/[04_auto_test.sh] /"

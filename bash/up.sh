#!/bin/bash

cd master
vagrant up
cd ..

cd node1
vagrant up
cd ..

. ./01_setup_hostname.sh
. ./02_node1.sh
. ./03_master_accept.sh 

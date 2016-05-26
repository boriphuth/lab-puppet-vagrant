#!/bin/bash
cd ./master
vagrant destroy -f default 
cd ..

cd ./node1
vagrant destroy -f default
cd ..

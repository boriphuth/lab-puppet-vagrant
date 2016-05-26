#!/bin/bash
echo nameserver 192.168.0.1 >> /etc/resolv.conf  
echo 127.0.1.1 node1.smb.com >> /etc/hosts

ntpdate pool.ntp.org
cd /tmp
#wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
#dpkg -i puppetlabs-release-trusty.deb
#apt-get update
#apt-get -y --force-yes install puppet

wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
sudo dpkg -i puppetlabs-release-pc1-trusty.deb
sudo apt-get update

sudo apt-get -y --force-yes install puppet-agent

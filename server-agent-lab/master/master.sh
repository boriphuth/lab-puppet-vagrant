#!/bin/bash
echo nameserver 192.168.0.1 >> /etc/resolv.conf  
echo 127.0.1.1 master.smb.com >> /etc/hosts
ntpdate pool.ntp.org
cd /tmp
#wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
#dpkg -i puppetlabs-release-trusty.deb
#apt-get update
#apt-get -y --force-yes install puppetmaster

# fix issue
# https://tickets.puppetlabs.com/browse/PUP-2566
# Debian puppet packages set templatedir which triggers deprecation warning
#sudo sed -i '/templatedir/s/^/#/g' /etc/puppet/puppet.conf


wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
sudo dpkg -i puppetlabs-release-pc1-trusty.deb
sudo apt-get update

sudo apt-get -y --force-yes install puppet-agent
sudo apt-get -y --force-yes install puppetserver

# Setup locale file
sudo locale-gen en_US en_US.UTF-8 zh_TW zh_TW.UTF-8
sudo dpkg-reconfigure locales

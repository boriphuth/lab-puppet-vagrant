# lab-puppet-vagrant

A test lab for deployment the puppetmaster and puppet agent system from vagrant.

by Jing.

### Requirement
1. VirtualBox
2. Vagrant
```sh
	vagrant box add ubuntu/trusty64
```
3. puppet
```sh
	sudo apt-get install puppet-common 
	puppet module install lex-dnsmasq // dns server  
```

### Usage:
#### Initial the Infrastructure
Step 1. [puppet-master] Installed dns server and puppet master by vagrant puppet provisioner
```sh
vagrant up && vagrant ssh
```

Step 2. [node1] Installled puppet agent by vagrant puppet provisioner
```sh
vagrant up && vagrant ssh
```
#### Setup the certification to the new node1
Step 1. [node1] Request a certification for new installation
```sh
sudo puppet agent --test --server puppet-master
```

Step 2. [puppet-master] Sign the certification to node1
```sh
sudo puppet cert --list
sudo puppet cert --sign
```
#### Write the deployment code
[puppet-master] Write deployment main program in /etc/puppet/manifest/site.pp
```sh
node default {
    file { "/tmp/temp1.txt": content => "hello,first puppet manifest"; }
}
```

#### Run the agent
[node1] Run the puppet agent

>By default puppet agent retrieve and apply the configuration every 30 minutes. You can modify this with runinterval in /etc/puppet/puppet.conf or directly run the agent with the parameter --runinterval. Here, I set the run interval in 2 sec for example. This setting can be a time interval in seconds (30 or 30s), minutes (30m), hours (6h), days (2d), or years (5y).

```sh
sudo puppet agent -v --logdest=console --runinterval=2s --server puppet-master
```

# puppet-master node
#   1. puppet-master
#   2. DNS server
#
# by Jing.	

node default {
  $myhostname = "puppet-master"
  
  # setup name
  file { "/etc/hostname": 		content => $myhostname; 	}
  exec { "setup hostname":		command => "/bin/hostname ${myhostname}",	}
  
  # setup DNS
  # 	require: puppet module install lex-dnsmasq
  include dnsmasq
  dnsmasq::address { $myhostname:	ip  => '192.168.50.2',  }  
  dnsmasq::address { "node1":		ip  => '192.168.50.10',  }  
  dnsmasq::address { "node2":		ip  => '192.168.50.11',  }
  dnsmasq::address { "node3":		ip  => '192.168.50.12',  }
  
  # install puppetmaster
  #		ensure the puppetmaster is the latest
  #		require the the dnsmasq was ready
  package {'puppetmaster': ensure => latest, require => Service[dnsmasq]}
  
}

# Install puppet agent
# by Jing.


node default {
  # setup name & DNS server
  $myhostname = "node1"
  $domain_name_server_ip="192.168.50.2"
  
  file { "/etc/hostname": 		content => $myhostname; 	}
  exec { "setup hostname":		command => "/bin/hostname ${myhostname}",	}
  file { "/etc/resolv.conf": content => "nameserver ${domain_name_server_ip}"; }
  
  # install puppet agent
  package {'puppet': ensure => latest, }
}

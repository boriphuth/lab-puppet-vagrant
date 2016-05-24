node default {
    #notice("This message will show on puppet master node")
    #notice{"This message will show on puppet client node":}
    #notice{"This message will show on puppet client node":withpath => true,}
   
    file { "/tmp/temp1.txt": 
      content => "PASS!!\n"; }
}

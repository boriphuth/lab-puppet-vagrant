#!/bin/bash

# Test an IP address for validity:
# Usage:
#      valid_ip IP_ADDRESS
#      if [[ $? -eq 0 ]]; then echo good; else echo bad; fi
#   OR
#      if valid_ip IP_ADDRESS; then echo good; else echo bad; fi
# Reference:
#     http://www.linuxjournal.com/content/validating-ip-address-bash-script
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}


# PATH TO YOUR HOSTS FILE
ETC_HOSTS=/etc/hosts

# Function: changehostname
# Usage
#    change_hostname vm2_test
# Return
#    0: Success
#    1: Fail
function change_hostname() {
    local hostname_file=/etc/hostname
    local hosts_file=/etc/hosts
    local newhostname=$1

    if [ -z "$newhostname" ]; then
        echo "Usage: changehostname HOSTNAME"
        return 1
    fi
   
    # check hostname
    valid_hostname $newhostname
    if [[ $? -eq 1 ]]; then
        #echo "Invalid hostname: $newhostname"
        return 1
    fi

    # update /etc/hostname
    # sudo -- sh -c -e "echo '$newhostname' > ${hostname_file}";
    echo "$newhostname" | sudo tee ${hostname_file}

    # update /etc/hosts
    sudo sed -i "s#^.*\b127.0.1.1\b.*\$#127.0.1.1\t${newhostname}#g" ${hosts_file}

    # update the machine hostname
    echo "Change name: $HOSTNAME -> $newhostname"
    sudo hostname ${newhostname}

    #sudo hostnamectl set-hostname $newhostname
}

#Function valid_hostanme
# Usage:
#    valid_hostname abc_123
#    if [[ $? -eq 0 ]]; then
#      echo  valid_hostname_test::OK
#    else
#       echo valid_hostname_test::Error
#    fi
# Return
#   0: valid
#   1: invalid
function valid_hostname(){
    local name=$1

    LC_CTYPE="C"
    name="${name//[^-0-9A-Z_a-z]/}"
    if [ "$name" != "" ] &&
       [ "$name" != "${name#[0-9A-Za-z]}" ] &&
       [ "$name" != "${name%[0-9A-Za-z]}" ] &&
       [ "$name" == "${name//-_/}" ] &&
       [ "$name" == "${name//_-/}" ] ; then
         if [[ $name == *"_"* ]]; then
             echo "valid_hostname::Error"
             return 1
         else
             echo "valid_hostname::OK"
             return 0
         fi
    else
        echo "valid_hostname::Error"
        return 1
    fi
}

function valid_hostname_test(){
    valid_hostname abc_123
    if [[ $? -eq 0 ]]; then
       echo  valid_hostname_test::OK
    else
        echo valid_hostname_test::Error
    fi

    valid_hostname "abc-123"
    if [[ $? -eq 0 ]]; then
        echo valid_hostname_test::OK
    else
        echo valid_hostname_test::Error
    fi

}


# Function: removehost
# Usage:
#   remove_host vm4
# Return:
#   0: success
#   1: fail
function remove_host() {
    local HOSTNAME=$1
    if [ -z "$HOSTNAME" ]; then
        echo "Usage: removehost HOSTNAME"
        return 1
    fi

    if [ -n "$(grep $HOSTNAME /etc/hosts)" ]
    then
        echo "$HOSTNAME Found in your $ETC_HOSTS, Removing now...";
        sudo sed -i".bak" "/$HOSTNAME/d" $ETC_HOSTS
        return 0
    else
        echo "$HOSTNAME was not found in your $ETC_HOSTS";
        return 1 
    fi
}

# Function: remove_host_array
# Usage:
#    HostnameArray=(vm1 vm2 vm3)
#    remove_host_array $HostnameArray
# Return
#    0: Success
#    1: Fail
function remove_host_array(){
    HostnameArray=$1
    for (( i=0; i<${#HostnameArray[@]}; i++)); do
       echo ${HostnameArray[i]}  
       remove_host ${HostnameArray[i]} 
    done
}

function remove_host_array_test(){
    HostnameArray=(vm1 vm2 vm3)
    remove_host_array $HostnameArray
}
 

function add_host_array(){
    HostNameArray=$1
    IPArray=$2

    for (( i=0; i<${#HostNameArray[@]}; i++)); do
       echo ${HostNameArray[i]} ${IPArray[i]} 
       add_host ${HostNameArray[i]} ${IPArray[i]} 
    done
}

function add_host_array_test(){
    HostNameArray=(vm1 vm2 vm3)
    IPArray=("10.109.62.118" "10.109.62.124" "10.109.62.138")
 
    add_host_array $HostNameArray $IPArray
}

# Function: addhost
# Usage:
#   . ./ip_utility.sh
#   add_host vm4 10.109.62.233
# Return:
#   0: success
#   1: fail
function add_host() {
    HOSTNAME=$1
    IP=$2
   
    valid_ip ${IP}
   
    if [[ $? -eq 1 ]]
    then 
        echo "Usage: addhost hostname ip"
        return 1
    fi

    HOSTS_LINE="$IP\t$HOSTNAME"
    if [ -n "$(grep $HOSTNAME /etc/hosts)" ]
        then
            echo "$HOSTNAME already exists : $(grep $HOSTNAME $ETC_HOSTS)"
        else
            echo "Adding $HOSTNAME to your $ETC_HOSTS";
            sudo -- sh -c -e "echo '$HOSTS_LINE' >> /etc/hosts";

            if [ -n "$(grep $HOSTNAME /etc/hosts)" ]
                then
                    echo "$HOSTNAME was added succesfully \n $(grep $HOSTNAME /etc/hosts)";
                else
                    echo "Failed to Add $HOSTNAME, Try again!";
            fi
    fi
}

function fun_puppet_enable(){
    # allows the puppet agent service to run
    sudo sed -i "s#^.*\bSTART\b.*\$#START=yes#g" /etc/default/puppet

}

# https://tickets.puppetlabs.com/browse/PUP-2566
# Debian puppet packages set templatedir which triggers deprecation warning
function fun_puppet_fix_issue_PUP2566(){
    echo "Fix issue: Debian puppet packages set templatedir which triggers deprecation warning."
    sudo sed -i '/templatedir/s/^/#/g' /etc/puppet/puppet.conf
}

function fun_puppet_master_memory(){
    variable="-Xms1g -Xmx1g -XX:MaxPermSize=256m"
    sudo sed -i "s#^.*\bJAVA_ARGS\b.*\$#JAVA_ARGS=\"${variable}\"#g" /etc/default/puppetserver

}

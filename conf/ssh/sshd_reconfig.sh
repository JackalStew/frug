#!/bin/bash
conf_file_set () {
    fname=$1
    key=$2
    val=$3
    regex="#\?$key.*"
    conf_line="$key $val"

    if grep --quiet "$regex" $fname
    then
        sed -i "s/$regex/$conf_line/g" $fname
    else
        echo $conf_line >> $fname
    fi
}

ssh_conf_file=/etc/ssh/sshd_config

# Uncomment these two to enable port forwarding
#conf_file_set $ssh_conf_file AllowTcpForwarding yes
#conf_file_set $ssh_conf_file GatewayPorts yes

echo "SSHD reconfigure script complete. IP address is: $(hostname -I)"

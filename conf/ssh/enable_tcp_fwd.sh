sed -i 's/AllowTcpForwarding no/AllowTcpForwarding yes/g' /etc/ssh/sshd_config
echo GatewayPorts yes >> /etc/ssh/sshd_config
echo "Port forwarding enabled. IP address is: $(hostname -I)"

#!/bin/bash
###########################################
################ Variables ################
###########################################
HOSTNAME='newserver'
USERNAME='deploy'
#PACKAGES='htop nano sudo python-minimal openssl'

###########################################
################# Updates #################
###########################################
#apt-get update && apt-get upgrade -y
#apt-get dist-upgrade

###########################################
################## Apps ###################
###########################################
#apt-get install $PACKAGES -y

###########################################
################## SSH ####################
###########################################

# Add SSH Key for default user
#mkdir /home/$USERNAME/.ssh/
#cat > /home/$USERNAME/.ssh/authorized_keys <<EOF
#SSH-KEY HERE
#EOF
#chmod 700 /home/$USERNAME/.ssh
#chmod 600 /home/$USERNAME/.ssh/authorized_keys
#chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
# Add SSH Key for root user
#mkdir /root/.ssh/
#cat > /root/.ssh/authorized_keys <<EOF
#SSH-KEY HERE
#EOF
#chmod 700 /root/.ssh
#chmod 600 /root/.ssh/authorized_keys
#chown -R root:root /root/.ssh

# Edit /etc/ssh/sshd_config
#sed -i '/^PermitRootLogin/s/prohibit-password/yes/' /etc/ssh/sshd_config
#sed -i -e 's/#PasswordAuthentication/PasswordAuthentication/g' /etc/ssh/sshd_config

###########################################
################# Network #################
###########################################
mv /etc/netplan/01-netcfg.yaml /etc/netplan/01-netcfg.yaml.bk
cat > /etc/netplan/01-netcfg.yaml <<EOF
network:
 version: 2
 renderer: networkd
 ethernets:
  ens18:
    dhcp4: no
    dhcp6: no
    addresses: [192.168.1.33/24]
    gateway4: 192.168.1.1
    nameservers:
      addresses: [8.8.8.8, 8.8.4.4]
EOF

###########################################
############# Change Hostname #############
###########################################
hostn=$(cat /etc/hostname)
sudo sed -i "s/$hostn/$HOSTNAME/g" /etc/hosts
sudo sed -i "s/$hostn/$HOSTNAME/g" /etc/hostname
sudo reboot

#!/bin/bash
################ Variables ################
HOSTNAME='usenet-1804-4gb'
USERNAME='deploy'

################# Updates #################
#apt update && apt-get upgrade -y
#apt dist-upgrade

################## Apps ###################
apt install qemu-guest-agent nfs-common -y

################## SSH ####################
# Add SSH Key for default user
mkdir /home/$USERNAME/.ssh/
cat > /home/$USERNAME/.ssh/authorized_keys <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAgEAi97di/v2xlKxk7LpXoUrPOm4koFY0Tq+z+3VF3iWql3xGnUMwoaAGBdDaJ9R3UIEpTMyb0GU0HUeLKshg8mbRCPAwRieWUe5Ps4VXLkENPiHywBvS64YDM1PXM4m1fop8bNKM0e8A3+sUhavCdgmEGmN9xQGwPm68SJclqyd3td2bWOCf35khDtbpbFLafnCZlil8s4HePcAboT9193oQXWFaLev6uI+rknL21BuUBs5t0K01VXdskL1PzQsh5yR8WSapd9z7uTOVamk7j7x6ejajbf+75oHipez+/pTQx75DDRQhnuduTa5CZQ9qyKB0eIJ1Ey++39Z4fS1LOu7yqQjncBe1szsnCsqTZxe4HdFRBSjpM9qs3bpX4rLB2bg7sdjDgbqPKe0pMrwx3FGo+s5PbQOsrPCnzpKlhEcUX7TIO02qH6B6qqatqhSLrJmjjhlg0sEMpQfnopcHsVX7X1/6oz1fG9xPtNTNVJbhFheyotCqnpvdIn+0W+2LT9NIE33z9eEusdurrlW6GtOPwmEeq1FNYizozRM+Mo06QqcTNcVMsqphrAQUZ5O3Zz3zN2S1iq16lRHU1X/nyRwbckQvWJQ0Zg+3PqlQclUJ4dcDMA4mN3KWx+qu1CsTuIQpN4H+OIONio2kSdFEDrZS2M6NvAo5QIEB0xTwGV3GLc=
EOF
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
# Edit /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

################# Network #################
mv /etc/netplan/01-netcfg.yaml /etc/netplan/01-netcfg.yaml.bk
cat > /etc/netplan/01-netcfg.yaml <<EOF
network:
 version: 2
 renderer: networkd
 ethernets:
  ens18:
    dhcp4: no
    dhcp6: no
    addresses: [192.168.1.61/24]
    gateway4: 192.168.1.1
    nameservers:
      addresses: [192.168.1.1, 8.8.8.8, 8.8.4.4]
EOF

##PLEX
#apt install nfs-common -y
mkdir /mnt/storage
#mkdir -p /var/lib/plexmediaserver/Library/Application\ Support/Plex\ Media\ Server
#adduser --system -group --no-create-home plex
#chown -R plex:plex /var/lib/plexmediaserver/

###########################################
############# Change Hostname #############
###########################################
hostn=$(cat /etc/hostname)
sudo sed -i "s/$hostn/$HOSTNAME/g" /etc/hosts
sudo sed -i "s/$hostn/$HOSTNAME/g" /etc/hostname
sudo reboot

#!/bin/sh

users=$(cat /etc/ssh/config/authorized_keys | cut -d: -f1)

for USRN in $users; do
  	echo "Creating user $USRN"
	useradd -m -s /bin/bash $USRN
	echo "cat /home/motd" >> /home/$USRN/.bashrc
done

exec /usr/sbin/sshd -D -e
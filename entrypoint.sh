#!/bin/sh
IFS=","
for USER in $USERS; do
    echo "Adding $USER..."
    adduser -h "/home/$USER" -s /bin/bash -D "$USER" wheel
    passwd -u "$USER"
    mkdir -p "/home/$USER/.ssh"
    curl -so "/home/$USER/.ssh/authorized_keys" "https://github.com/$USER.keys"
    chown -R "$USER:$USER" "/home/$USER/.ssh"
    chmod 755 "/home/$USER/.ssh"
    chmod 644 "/home/$USER/.ssh/authorized_keys"
done

if [ -d /efs/keys ]; then
    echo "Copying host keys from efs..."
    cp /efs/keys/ssh_host* /etc/ssh/
    chmod 600 /etc/ssh/ssh_host*key
    chmod 644 /etc/ssh/ssh_host*key.pub
    ls -l /etc/ssh/
fi

echo "%wheel  ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/wheel

ssh-keygen -A
exec /usr/sbin/sshd -D -e "$@"
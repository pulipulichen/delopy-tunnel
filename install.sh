#!/bin/bash

apt-get update
apt-get install -y curl wget

wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
dpkg -i cloudflared-linux-amd64.deb
rm -rf cloudflared-linux-amd64.deb

rm *.sh

wget https://pulipulichen.github.io/delopy-tunnel/assets/startup.sh
wget https://pulipulichen.github.io/delopy-tunnel/assets/random_sleep_startup.sh

chmod +x *.sh

timedatectl set-timezone Asia/Taipei

# Function to check and append command to /etc/crontab if not present
check_and_append_crontab() {
    local command_to_check="$1"
    if ! grep -q "$command_to_check" /etc/crontab; then
        echo "$command_to_check" | sudo tee -a /etc/crontab > /dev/null
        echo "Command appended to /etc/crontab"
    else
        echo "Command already exists in /etc/crontab"
    fi
}

check_and_append_crontab "@reboot root /root/startup.sh"
check_and_append_crontab "0 3 * * * root /root/random_sleep_startup.sh"

reboot
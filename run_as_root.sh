dd if=/dev/zero of=/swapfile bs=1G count=16 status=progress
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

printf '\n/swapfile\tnone\tswap\tsw\t0\t0\n' >> /etc/fstab

apt install htop

sysctl vm.swappiness=6
sysctl vm.vfs_cache_pressure=10
printf '\nvm.swappiness=6' >> /etc/sysctl.conf
printf '\nvm.vfs_cache_pressure=10\n' >> /etc/sysctl.conf

useradd eth -d /home/eth -m
usermod --password "$(echo "eth" | openssl passwd -1 -stdin)" eth
echo "eth ALL=(ALL:ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/eth
chmod 0440 /etc/sudoers.d/eth

apt update
apt install -y unattended-upgrades update-notifier-common

cat <<EOT > /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Remove-New-Unused-Dependencies "true";

# This is the most important choice: auto-reboot.
# This should be fine since Rocketpool auto-starts on reboot.
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "02:00";
EOT
systemctl restart unattended-upgrades

ufw default deny incoming comment 'Deny all incoming traffic'
ufw allow "22/tcp" comment 'Allow SSH'

ufw allow 30303/tcp comment 'Execution client port, standardized by Rocket Pool'
ufw allow 30303/udp comment 'Execution client port, standardized by Rocket Pool'

ufw allow 9001/tcp comment 'Consensus client port, standardized by Rocket Pool'
ufw allow 9001/udp comment 'Consensus client port, standardized by Rocket Pool'

ufw allow 3100/tcp comment 'Allow grafana from anywhere'

ufw enable
su -l eth
mkdir -p ~/.ssh

curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

apt-get update
apt-get install tailscale
tailscale up

printf '\nPermitRootLogin no\n' >> /etc/ssh/sshd_config
printf '\nPubkeyAuthentication yes\n' >> /etc/ssh/sshd_config




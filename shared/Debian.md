 <p align="left">
  <a href="https://github.com/vdarkobar/Home-Cloud#self-hosted-cloud">Home</a>
</p>  
  
# Debian
## Proxmox Debian Template
  
- Create ProxMox VM (2CPU/2GBRAM/16GBHDD)
- Start Debian installation
- Do not set *root password* during installation *(this way created user will gain sudo privileges)*.
- For ProxMox VM disk *Resize* option to work, create VM without SWAP Partition during install process  
*(VM > Hardware > Hard Disk > Disk Action > Resize)*
```bash
Partition disks > Manual > Continue
Select disk > SCSI3 QEMU HARDDISK > Continue
Create new empty Partition > Yes > Continue
New Partition Size > Continue
Primary > Continue
Bootable Flag > On > Done setting up the Partition > Continue
Finish partitioning and write changes to the disk > Continue
Return to the partitioning menu > No > Continue
Write changes to the disk > Yes > Continue
```
- Add SSH Server  
  
### Login to <a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Bastion.md#bastion">Bastion</a> and copy ID to VM:
```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@debiantemplate
```
  
Test: SSH to VM:
```bash
ssh user@ip
```
  
### Create *SWAP* file:
```bash
sudo -i
dd if=/dev/zero of=/swapfile bs=1024 count=1536000
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile       swap    swap    defaults        0 0" >> /etc/fstab
```
Exit and reboot.
  
### Update and install packages: 
```bash
sudo apt update && \
sudo apt install -y \
  git \
  ufw \
  wget \
  curl \
  tmux \
  gnupg2 \
  argon2 \
  fail2ban \
  cloud-init \
  bash-completion \
  fonts-powerline \
  qemu-guest-agent \
  unattended-upgrades \
  cloud-initramfs-growroot \
  software-properties-common
```
  
### Update and install packages
*(use this if building template to run Docker)*: 
```bash
sudo apt update && \
sudo apt install -y \
  git \
  gpg \
  ufw \
  wget \
  curl \
  tmux \
  gnupg2 \
  argon2 \
  fail2ban \
  cloud-init \
  lsb-release \
  python3-pip \
  gnupg-agent \
  apache2-utils \
  bash-completion \
  fonts-powerline \
  ca-certificates \
  qemu-guest-agent \
  apt-transport-https \
  unattended-upgrades \
  cloud-initramfs-growroot \
  software-properties-common
```
  
### Follow these <a href="https://github.com/vdarkobar/dotfiles">steps</a> to setup *bash* and <a href="https://github.com/tmux/tmux/wiki">tmux</a>.  
  
### Enable *unattended-upgrades*:
```bash
sudo dpkg-reconfigure --priority=low unattended-upgrades
```
Edit file:
```bash
sudo nano /etc/apt/apt.conf.d/50unattended-upgrades
```
Uncomment:
```bash
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-New-Unused-Dependencies "true";
Unattended-Upgrade::Remove-Unused-Dependencies "false";    		# change to "true"
Unattended-Upgrade::Automatic-Reboot "false";
Unattended-Upgrade::Automatic-Reboot-Time "02:00";
```
  
### Lockdown SSH:
```bash
sudo nano /etc/ssh/sshd_config
```
Change values to:
```bash
PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM no
```
  
Add line at the end to allow only your username (*more can be added, in line, space separated*):
```bash
AllowUsers <username>
```
```bash
sudo systemctl restart ssh
```
  
If needed, search for the entry **# Port 22**, uncomment and replace 22 with a port number between 49152 and 65535 *(Dynamic/private ports)*: 
  
### Fail2Ban:
```bash
systemctl status fail2ban
sudo fail2ban-client status
```
Configuration:
```bash
cd /etc/fail2ban
sudo cp jail.conf jail.local
sudo nano jail.local
```
Enabling jails (explicit rule), under jail name add:
```bash
enabled = true
```
Change if needed:
```bash
[DEFAULT]
$ bantime =10m
$ findtime =10m
$ maxretry=5
```
Uncomment "ignoreip" (*if needed add additional ip's*):
```bash
ignoreip = 127.0.0.1/8 ::1    			# localhost
```
```bash
sudo systemctl restart fail2ban
```
Options:
```bash
sudo fail2ban-client set sshd banip <ip>
sudo fail2ban-client set sshd unbanip <ip>
```
Check logs: 
```
sudo tail /var/log/auth.log
```
  
### UFW:
```bash
sudo ufw limit 22/tcp comment "SSH"
sudo ufw enable
```
Set defaults, Global blocks:
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```
```bash
sudo ufw reload
sudo ufw status numbered
```
Check Listening Ports
```bash
sudo ss -tupln
netstat -tunlp
```
Prevent PING:
```bash
sudo nano /etc/ufw/before.rules
```
Find and edit section: **# ok icmp codes for INPUT**, add (*as first*) line:
```bash
-A ufw-before-input -p icmp --icmp-type echo-request -j DROP
```
  
### Secure the server:
Secure Shared Memory:
```bash
sudo nano /etc/fstab
```
Copy paste next line, below the text at the very bottom of the file:
```bash
none /run/shm tmpfs defaults,ro 0 0
```
Edit file:
```bash
sudo nano /etc/sysctl.conf
```
Uncoment:
```bash
	##Spoof protection
net.ipv4.conf.def......
net.ipv4.conf.all......
	##ICMP redirects MITM attacks
net.ipv4.conf.all......
net.ipv6.conf.all......
	##send ICMP redirects not a router
net.ipv4.conf.all......
	##accept IP source route not a router
net.ipv4.conf.all......
net.ipv6.conf.all......
	##log Martians
net.ipv4.conf.all......
```
```bash
sudo sysctl -p
```
  
### Fix machine-id change:  
*cloned VM will have different MAC addresses)*
```bash
cat /etc/machine-id
sudo truncate -s 0 /etc/machine-id
sudo rm /var/lib/dbus/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id
ls -l /var/lib/dbus/machine-id
```
  
### Option to disable root account password:
Lock the account password:
```bash
sudo passwd -l root
```
  
### Cloud-init:
```bash
sudo nano /etc/cloud/cloud.cfg
```
Remove (what you are not using):
```bash
# this can be used by upstart jobs for 'start on cloud-config'.
- snap
- snap_config  # DEPRECATED- Drop in version 18.2
- ubuntu-advantage
- disable-ec2-metadata
- byobu

#The modules that run in the 'final' stage
cloud_final_modules:
 - snappy  # DEPRECATED- Drop in version 18.2
 - fan
 - landscape
 - lxd
 - puppet
 - chef
 - mcollective
 - salt-minion
 - rightscale_userdata
```
  
#### Clear old SSH host keys:
```bash
cd /etc/ssh/
sudo rm ssh_host_*
```
  
#### Poweroff VM to convert to template:
```bash
sudo apt clean && sudo apt autoremove && sudo poweroff
```
  
#### Add cloud-init drive to VM: 
  
- *VM > Hardware > Add > Cloudinit drive*  
Add login data to Cloudinit drive  
VM > Cloudinit  
- *Add: username and password, public key*  
Click  
- *Regenerate Image*  
  
#### Convert VM to Template.  
  
  
### Create new template from old template:
  
#### Clone template and log in to the VM:
  
```bash
sudo rm /etc/ssh/ssh_host_*
sudo truncate -s 0 /etc/machine-id
sudo apt clean && sudo apt autoremove && sudo poweroff
```
  
VM > Cloudinit    
Click  
- *Regenerate Image* 
  
#### Convert VM to Template. 
  
<a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Debian.md#debian">top of the page</a>

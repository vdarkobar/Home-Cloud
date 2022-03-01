# Debian
## Proxmox Debian Template
  
<p align="left">
  <a href="https://github.com/vdarkobar/Home-Cloud">Home</a>
</p>  
  
- Install Debian VM (2CPU/2GBRAM/16GBHDD), add SSH Server  
- Dont set root password during installation (created user will have sudo privilages)  
  
#### For automatic *disk resize* to work, create VM without SWAP Partition during install process:
```
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

### Login to <a href="https://github.com/vdarkobar/shared/blob/main/Bastion.md#bastion">Bastion</a> and copy ID to VM:
```
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@ip
```
  
Test: SSH to VM:
```
ssh user@ip
```
  
### Replace content od the: *~/.bashrc* file with this one: <a href="https://github.com/vdarkobar/shared/blob/main/.bashrc">.bashrc</a> then log out and log back in.
  
#### Create *SWAP* file:
```
sudo -i
dd if=/dev/zero of=/swapfile bs=1024 count=1536000
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile       swap    swap    defaults        0 0" >> /etc/fstab
```
Exit and reboot.
  
### Update and install packages v01: 
```
sudo apt update && \
sudo apt install -y \
  ufw \
  wget \
  curl \
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
  
### Update and install packages v02 (*Docker, Traefik etc*): 
```
sudo apt update && \
sudo apt install -y \
  git \
  gpg \
  ufw \
  wget \
  curl \
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
  
### Enable *unattended-upgrades*:
```
sudo dpkg-reconfigure --priority=low unattended-upgrades
```
Edit file:
```
sudo nano /etc/apt/apt.conf.d/50unattended-upgrades
```
Uncomment:
```
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-New-Unused-Dependencies "true";
Unattended-Upgrade::Remove-Unused-Dependencies "false";    <<< change to "true"
Unattended-Upgrade::Automatic-Reboot "false";
Unattended-Upgrade::Automatic-Reboot-Time "02:00";
```
  
### Lockdown SSH:
```
sudo nano /etc/ssh/sshd_config
```
Change values to:
```
PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM no
```	
  
Add line at the end to allow only your username (*more can be added, in line, space separated*):
```
AllowUsers <username>
```
```
sudo systemctl restart ssh
```
  
If needed, search for the entry **# Port 22**, uncomment and replace 22 with a port number between 49152 and 65535 (Dynamic/private ports): 
  
### Fail2Ban:
```
systemctl status fail2ban
sudo fail2ban-client status
```
Configuration:
```
cd /etc/fail2ban
sudo cp jail.conf jail.local
sudo nano jail.local
```
Enabling jails (explicit rule), under jail name add:
```
enabled = true
```
Change if needed:
```
[DEFAULT]
$ bantime =10m
$ findtime =10m
$ maxretry=5
```
Uncomment "ignoreip" (*if needed add additional ip's*):
```	
ignoreip = 127.0.0.1/8 ::1    <<< localhost
```	
```
sudo systemctl restart fail2ban
```
Options:
```
sudo fail2ban-client set sshd banip <ip>
sudo fail2ban-client set sshd unbanip <ip>
```
Check logs: 
```
sudo tail /var/log/auth.log
```
  
### UFW:
```
sudo ufw limit 22/tcp comment "SSH"
sudo ufw enable
```
Set defaults, Global blocks:
```
sudo ufw default deny incoming
sudo ufw default allow outgoing
```
```
sudo ufw reload
sudo ufw status numbered
```
Check Listening Ports
```
sudo ss -tupln
netstat -tunlp
```
Prevent PING:
```
sudo nano /etc/ufw/before.rules
```
Find and edit section: **# ok icmp codes for INPUT**, add (*as first*) line:
```
-A ufw-before-input -p icmp --icmp-type echo-request -j DROP
```
  
### Secure the server:
Secure Shared Memory:
```
sudo nano /etc/fstab
# Copy paste next line, below the text at the very bottom of the file:

none /run/shm tmpfs defaults,ro 0 0
```
Edit file:
```
sudo nano /etc/sysctl.conf
```
Uncoment:
```
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
```
sudo sysctl -p
```
  
### Fix machine-id change:  
(*cloned VM to have different MAC addresses*)
```
cat /etc/machine-id
sudo truncate -s 0 /etc/machine-id
sudo rm /var/lib/dbus/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id
ls -l /var/lib/dbus/machine-id
```
### Option to disable root account:
To disable, you can remove the password of the root account or lock it down, or even do both:
Remove the root password:             << use this one, lock the root account after cloning VM
```
sudo passwd -d root
```
Lock the account:
```
sudo passwd -l root
```
  
### Cloud-init:
```
sudo nano /etc/cloud/cloud.cfg
```
Remove (what you are not using):
```
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
```
cd /etc/ssh/
sudo rm ssh_host_*
```
  
#### Poweroff VM to convert to template:
```
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
  
```
sudo rm /etc/ssh/ssh_host_*
sudo truncate -s 0 /etc/machine-id
sudo apt clean && sudo apt autoremove && sudo poweroff
```
  
VM > Cloudinit    
Click  
- *Regenerate Image* 
  
#### Convert VM to Template. 
  
<a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Debian.md#debian">top of the page</a>

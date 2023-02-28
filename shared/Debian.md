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
  ufw \  
  git \
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
  
### Follow <a href="https://github.com/vdarkobar/dotfiles">these steps</a> to setup *bash* and <a href="https://github.com/tmux/tmux/wiki">tmux</a> *dotfiles*.  
  
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
  
If needed, search for the entry **# Port 22**, uncomment and replace 22 with a port number between 49152 and 65535 *(Dynamic/private ports)*.  
Adjust, if changed, in UFW configuration section.
  
### CrowdSec
  
#### Install our repositories
```bash
curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | sudo bash
```
  
#### Install CrowdSec
```bash
sudo apt update
sudo apt install crowdsec
```

To cleanup errors, edit file:
```bash
sudo nano /etc/crowdsec/config.yaml
```

To remove sqlite error:	
```bash
db_config:
  log_level: info
  type: sqlite
  db_path: /var/lib/crowdsec/data/crowdsec.db
  use_wal: true						# add this line
```

To edit Ports numbers, if they are already in use (Port 8080, 6060):
```bash
api:
  client:
    insecure_skip_verify: false
    credentials_path: /etc/crowdsec/local_api_credentials.yaml
  server:
    log_level: info
    listen_uri: 127.0.0.1:8080				# edit Port number
...
prometheus:
  enabled: true
  level: full
  listen_addr: 127.0.0.1
  listen_port: 6060					# edit Port number
```

Enter same Port number (8080), if changed, here:
```bash
sudo nano /etc/crowdsec/local_api_credentials.yaml
```
```bash
url: http://127.0.0.1:8080				# edit Port number
```

Restart CrowdCSec
```bash
sudo systemctl restart crowdsec
sudo systemctl status crowdsec
```
  
#### CrowdSec has already scanned your system and enabled the most „common“ scenarios
```bash
sudo cscli scenarios list
```
  
#### To run Setup again, in order to detect new services or install available Collections:
Collections contains parsers and scenarios to protect system.
```bash
sudo /usr/share/crowdsec/wizard.sh -c
```
  
#### Install a bouncer
```bash
sudo apt install crowdsec-firewall-bouncer-iptables
```

```bash
sudo systemctl start crowdsec-firewall-bouncer
sudo systemctl status crowdsec-firewall-bouncer
```

```bash
sudo cscli bouncers list
sudo cscli decisions list
```
  
#### Debug 

#### CrowdSec Log
```bash
sudo tail -f /var/log/crowdsec.log
```

#### Bouncer Log
```bash
sudo tail -f /var/log/crowdsec-firewall-bouncer.log
```
  
Useful CLI commands
```bash
# List parsers
cscli parsers list
# List collections
cscli collections list
# List all scenarios
cscli scenarios list
# List all bouncers
cscli bouncers list
# list everything enabled
cscli hub list
# List all configs
cscli hub list -a
# Show Log metrics (useful for debugging)
cscli metrics
# List recent decisions
cscli decisions list
# List all decisions
cscli decisions list -a
# List ban decisions 
cscli decisions list -t ban
# Delete a decision (by ip)
cscli decisions delete -i 1.2.3.4
# Update all configs (from hub)
cscli update
cscli upgrade
```
  
Directories:
The application lives in the folder \etc\crowdsec
The data is stored in the folder \lib\crowdsec\data
  
check:
```bash
sudo nano /etc/crowdsec/acquis.yaml
```
  
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
	##prevent some spoofing attacks
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
...
# this can be used by upstart jobs for 'start on cloud-config'.
- snap
- snap_config  # DEPRECATED- Drop in version 18.2
- ubuntu-advantage
- disable-ec2-metadata
- byobu
...
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
 ...
```
  
#### Clear old SSH host keys:
```bash
cd /etc/ssh/
sudo rm ssh_host_*
```
  
#### Clear bash shell history
```bash
history -c
```
  
#### Poweroff VM to convert to template:
```bash
sudo apt clean && sudo apt autoremove && sudo poweroff
```
  
__Add CloudInit drive to VM:__  
  
*VM > Hardware > Add > Cloudinit drive*  
  
Add login details to Cloudinit drive:  
  
*VM > Cloudinit > Add: User, Password, SSH public key > Regenerate Image*  
  
Convert VM to Template.  
  
*VM > Convert to template*  
  
### Create new template from old template:
  
#### Clone template and log in to the VM:
  
```bash
sudo rm /etc/ssh/ssh_host_*
sudo truncate -s 0 /etc/machine-id
history -c
sudo apt clean && sudo apt autoremove && sudo poweroff
```
  
VM > Cloudinit > *Regenerate Image* 
  
#### Convert VM to Template. 
  
<a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Debian.md#debian">top of the page</a>

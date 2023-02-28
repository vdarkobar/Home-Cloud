<p align="left">
  <a href="https://github.com/vdarkobar/Home-Cloud#self-hosted-cloud">Home</a>
</p>  
  
# Bastion
## Create Bastion Server

<p align="center">
  <img src="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/bastion.webp">
</p>
  
*Create <a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Proxmox.md#proxmox">Proxmox</a> VM: (1CPU/1GBRAM/16GBHDD) using <a href="https://www.debian.org/">Debian</a>, add SSH Server during installation.*  
*Do not set root password during installation (this way created user will gain sudo privileges).*  
  
### Update, install packages and reboot:
```bash
sudo apt update && sudo apt upgrade -y && \
sudo apt install -y \
  ufw \
  git \
  curl \
  wget \
  tmux \
  gnupg2 \
  fail2ban \
  net-tools \
  python3-pip \
  qemu-guest-agent \
  unattended-upgrades
```
  
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
Unattended-Upgrade::Remove-Unused-Dependencies "false";   		 #change to "true"
Unattended-Upgrade::Automatic-Reboot "false";
Unattended-Upgrade::Automatic-Reboot-Time "02:00";
```
  
### Follow these <a href="https://github.com/vdarkobar/dotfiles">steps</a> to setup *bash* and <a href="https://github.com/tmux/tmux/wiki">tmux</a>.  
  
### Reboot Server:
```bash
sudo reboot
```
  
### SSH:

Edit:
```bash
sudo nano /etc/ssh/sshd_config
```
Add line at the end to allow only your username (*more can be added, in line, space separated*):
```bash
AllowUsers <username>
```
```bash
sudo systemctl restart ssh
```

### Fail2Ban:
```bash
sudo systemctl status fail2ban
sudo fail2ban-client status
```
Config:
```bash
cd /etc/fail2ban
sudo cp jail.conf jail.local
sudo nano jail.local
```
Enabling jails (explicit rule), under jail name add:
```bash
enabled = true
```
Uncomment "ignoreip", add additional ip's:
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
```bash
sudo tail /var/log/auth.log
```
  
### UFW:
```bash
sudo ufw limit 22/tcp comment "SSH"
```
```bash
sudo ufw enable
```
Set defaults, Global blocks *(probably already done by default)*:
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw reload
sudo ufw status numbered
```      
Check Listening Ports:
```bash
netstat -tunlp
```
  
### Secure the server:
Secure Shared Memory, edit:  

```bash
sudo nano /etc/fstab
```
Paste below text the very bottom of the file:
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
Test:
```bash
sudo sysctl -p
```
  
### Lock root account password:

```bash
sudo passwd -l root
```
  
### Install *google-authenticator* for Debian/Ubuntu-based systems:  
```bash
sudo apt install libpam-google-authenticator
```
Config file: *~/.google_authenticator*
  
Run command:
```bash
google-authenticator -d -f -t -r 3 -R 30 -W
```
Select: *time-based* codes.
```bash
# Options used: 
#    disallow reuse of the same token twice, 
#    issue time-based rather than counter-based codes, 
#    limit the user to a maximum of three logins every 30 seconds.
```

---  
  
Output >> *QR code + Backup codes*  > use it to setup <a href="https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en&gl=US">Google Authenticator</a> app on your smartphone. Save backup codes.

---  
  

Edit the PAM configuration for the sshd service:  
```bash
sudo nano /etc/pam.d/sshd
```
Change the default auth so that SSH won’t prompt users for a password if they don’t present a 2-factor token, comment out:  
```bash
# @include common-auth
```
Add at the end:  
```bash
auth required pam_google_authenticator.so nullok
```
Tell SSH to require the use of *2-factor auth*. Edit the */etc/ssh/sshd_config* file to allow the use of *PAM* for credentials:  
```bash
sudo nano /etc/ssh/sshd_config
```
Change:  
```bash
ChallengeResponseAuthentication yes
```
Add at the end: 
```bash
AuthenticationMethods keyboard-interactive
#AuthenticationMethods publickey,keyboard-interactive				# If you are using PKI
```
Restart sshd:  
```bash
sudo systemctl restart sshd && logout
```
Test logging in using Verification Code.
  
### Generate keys:
```bash
ssh-keygen -t ed25519 -a 200							# most secure encryption
```
*The parameter -a defines the number of rounds for the key derivation function. The higher this number, the harder it will be for someone trying to brute-force the password of your private key — but also the longer you will have to wait during the initialization of an SSH login session.*
	
Copy your ID ( *public.key* ) to <a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Debian.md">desired VM</a> and test:
```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@ip
```
```bash
ssh user@ip
```
<a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Bastion.md#bastion">top of the page</a>

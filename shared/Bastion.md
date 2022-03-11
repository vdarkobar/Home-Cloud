<p align="left">
  <a href="https://github.com/vdarkobar/Home-Cloud#self-hosted-cloud">Home</a>
</p>  
  
# Bastion
## Create Bastion Server

<p align="center">
  <img src="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/bastion.webp">
</p>
  
*Create <a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Proxmox.md#proxmox">Proxmox</a> VM: (1CPU/1GBRAM/16GBHDD), add SSH Server.*  
*Do not set root password during installation (created user will have sudo privileges).*  
  
### Update, install packages and reboot:
```
sudo apt update && sudo apt upgrade -y && \
sudo apt install -y \
  ufw \
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
  
#### Setup *bash* and *tmux*: <i><a href="https://github.com/vdarkobar/dotfiles">.profiles</a></i>.  
  
Reboot Server.
```
sudo reboot
```
  
### SSH:  

Edit:
```
sudo nano /etc/ssh/sshd_config
```	    
Add line at the end:
```
AllowUsers <username>					# adjust <username>
```
```
sudo systemctl restart ssh
```

### Fail2Ban:
```
sudo systemctl status fail2ban
sudo fail2ban-client status
```
Config:
```
cd /etc/fail2ban
sudo cp jail.conf jail.local
sudo nano jail.local
```
Enabling jails (explicit rule), under jail name add:
```
enabled = true
```
Uncomment "ignoreip", add additional ip's:
```	
ignoreip = 127.0.0.1/8 ::1    <<< localhost
```	
```
sudo systemctl restart fail2ban
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
sudo ufw reload
sudo ufw status numbered
```      
Check Listening Ports:
```
netstat -tunlp
```
  
### Secure the server:
Secure Shared Memory, edit:  

```
sudo nano /etc/fstab
```
Paste below text the very bottom of the file:
```
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
Test:
```
sudo sysctl -p
```
  
### Disable root account:
To disable, you can remove the password of the root account or lock it down, or even do both:  
  
Remove the root password:
```
sudo passwd -d root
```
Lock the account:
```
sudo passwd -l root
```
  
### Install *google-authenticator* for Debian/Ubuntu-based systems:  
Config file: *~/.google_authenticator*  
```
sudo apt install libpam-google-authenticator
```
Run command:
```
google-authenticator -d -f -t -r 3 -R 30 -W
```
Select: *time-based* codes.
```
# Options used: 
#    disallow reuse of the same token twice, 
#    issue time-based rather than counter-based codes, 
#    limit the user to a maximum of three logins every 30 seconds.
```

---  
  
Output >> *QR code + Backup codes*  > use it to setup *google-authenticator app* on your smartphone. Save backup codes.

---  
  

Edit the PAM configuration for the sshd service:  
```
sudo nano /etc/pam.d/sshd
```
Change the default auth so that SSH won’t prompt users for a password if they don’t present a 2-factor token, comment out:  
```
# @include common-auth
```
Add at the end:  
```
auth required pam_google_authenticator.so nullok
```
Tell SSH to require the use of 2-factor auth. Edit the /etc/ssh/sshd_config file to allow the use of PAM for credentials:  
```
sudo nano /etc/ssh/sshd_config
```
Change:  
```
ChallengeResponseAuthentication yes
```
Add at the end: 
```
AuthenticationMethods keyboard-interactive
#AuthenticationMethods publickey,keyboard-interactive				# If you are using PKI
```
Restart sshd:  
```
sudo systemctl restart sshd && logout
```
Test logging in using Verification Code.
  
### Generate keys:
```
ssh-keygen -t ecdsa -b 521      <<< avoid
ssh-keygen -t ed25519 -a 200    <<< best signature scheme 2021
```
*The parameter -a defines the number of rounds for the key derivation function. The higher this number, the harder it will be for someone trying to brute-force the password of your private key — but also the longer you will have to wait during the initialization of an SSH login session.*
	
Copy ID (*public.key*) to <a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Debian.md">desired VM</a> and test:
```
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@ip
```
```
ssh user@ip
```
<a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Bastion.md#bastion">top of the page</a>

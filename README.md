  
---  
  
# *Self-hosted Home (Lab) Cloud*


<p align="center">
  <img src="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/infrastructure1.webp">
</p>
  
---  
  
## Add *domain* to <a href="https://dash.cloudflare.com/">CloudFlare</a> with the following settings<a href="https://support.cloudflare.com/hc/en-us/articles/201720164-Creating-a-Cloudflare-account-and-adding-a-website"> * </a>:
  


<pre>
SSL/TLS Mode - Full (strict)  

Edge Certificates:  
  Always Use HTTPS: ON  
  HTTP Strict Transport Security (HSTS): Enable
  -Max Age Header (max-age) 6 months
  -Apply HSTS policy to subdomains: ON
  -Preload: OFF(?)
  -No-Sniff Header: ON
  Minimum TLS Version: 1.2  
  Opportunistic Encryption: ON  
  TLS 1.3: ON  
  Automatic HTTPS Rewrites: ON  
  Certificate Transparency Monitoring: ON   
  
Security:
  Bot Fight Mode: ON 
  Security Level: Medium  
  Challenge Passage: 30 Minutes  
  Browser Integrity Check: ON  
</pre>

---  
  
## Install and Configure Proxmox Virtual Environment, create <a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Proxmox.md#proxmox"> * </a>:
  
  
1. ### *Bastion/Jump Debian Server <a href="https://github.com/vdarkobar/Bastion?tab=readme-ov-file#bastion"> * </a>*:
SSH connectivity to all of the VMs
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/vdarkobar/Bastion/main/setup.sh)"
```
  
2. ### *Debian VM/CT*:
Debian is a complete Free Operating System!

- Add free space (*if necessary*):  
> *VM > Hardware > Hard Disk > Disk Action > Resize*  
> *CT > Resources > Root Disk > Volume Action > Resize*  

- Run script to harden Linux server and to install one of the Services,
- Use *Bastion/Jump* Server to SSH in.  
  
---  
## *Services*:

<br><br>
### *Unbound DNS (with optional Pi-Hole) <a href="https://github.com/vdarkobar/unbound/tree/main?tab=readme-ov-file#unbound"> * </a>*:
validating, recursive, caching DNS resolver with DNS over TLS (DoT), with optional Pi-Hole install
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/vdarkobar/unbound/main/setup.sh)"
```

<br><br>
### *Samba file server <a href="https://github.com/vdarkobar/Samba/tree/main?tab=readme-ov-file#samba"> * </a>*:
file sharing across different operating systems over a network
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/vdarkobar/Samba/main/setup.sh)"
```

<br><br>
### *Nginx Proxy Manager (Docker) <a href="https://github.com/vdarkobar/NPM#nginx-proxy-manager"> * </a>*:
reverse Proxy for all of your Services
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/vdarkobar/NPM/main/setup.sh)"
```

<br><br>
### *Nextcloud <a href="https://github.com/vdarkobar/Nextcloud?tab=readme-ov-file#nextcloud"> * </a>*:
self hosted open source cloud file storage and colaboration
```bash
bash -c "$(wget -qLO - https://raw.githubusercontent.com/vdarkobar/Nextcloud/main/setup.sh)"
```


<br><br>
### *Nextcloud (Docker)*:
self hosted open source cloud file storage and colaboration
```bash
clear
RED='\033[0;31m'; NC='\033[0m'; echo -ne "${RED}Enter directory name: ${NC}"; read NAME; mkdir -p "$NAME"; \
cd "$NAME" && git clone https://github.com/vdarkobar/Nextcloud-D.git . && \
chmod +x setup.sh && \
./setup.sh
```
<a href="https://github.com/vdarkobar/Nextcloud-D/blob/main/README.md#nextcloud"> * </a>

<br><br>
### *Vaultwarden (Docker)*:
everything you need out of a password manager
```bash
clear
RED='\033[0;31m'; NC='\033[0m'; echo -ne "${RED}Enter directory name: ${NC}"; read NAME; mkdir -p "$NAME"; \
cd "$NAME" && git clone https://github.com/vdarkobar/Vaultwarden.git . && \
chmod +x setup.sh && \
./setup.sh
```
<a href="https://github.com/vdarkobar/Vaultwarden?tab=readme-ov-file#vaultwarden"> * </a>

<br><br>


<!-- This is commented out.
 
  <a href="https://github.com/vdarkobar/Matrix">Matrix</a>
  <a href="https://github.com/vdarkobar/NC">NextCloud</a>
  <a href="https://github.com/vdarkobar/WP">WordPress</a>
  <a href="https://github.com/vdarkobar/Calibre-web">Calibre-web</a>
  <a href="https://github.com/vdarkobar/Authelia">Authelia</a>

This is commented out. -->

<a href="https://github.com/vdarkobar/Home-Cloud/tree/main?tab=readme-ov-file#self-hosted-home-lab-cloud">top of the page</a>

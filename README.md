  
---  
  
# *Self-hosted Home (Lab) Cloud*


<p align="center">
  <img src="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/infrastructure.webp">
</p>
  
---  
  
### Login to <a href="https://dash.cloudflare.com/">CloudFlare</a> and add a domain name <a href="https://support.cloudflare.com/hc/en-us/articles/201720164-Creating-a-Cloudflare-account-and-adding-a-website">*</a> with the following settings:

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
  
### *Install and Configure Proxmox Virtual Environment and create two VM's*:
  
<a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Proxmox.md#proxmox"> * </a>
<br><br>
  
### *Bastion / Jump server*:
```bash
clear
sudo apt -y install git && \
RED='\033[0;31m'; NC='\033[0m'; echo -ne "${RED}Enter directory name: ${NC}"; read NAME; mkdir -p "$NAME"; \
cd "$NAME" && git clone https://github.com/vdarkobar/Bastion.git . && \
chmod +x create.sh && \
rm README.md && \
./create.sh
```

<a href="https://github.com/vdarkobar/Bastion/blob/main/README.md#bastion"> * </a>
<br><br>
  
### *Debian server template*:
```bash
clear
sudo apt -y install git && \
RED='\033[0;31m'; NC='\033[0m'; echo -ne "${RED}Enter directory name: ${NC}"; read NAME; mkdir -p "$NAME"; \
cd "$NAME" && git clone https://github.com/vdarkobar/DebianTemplate.git . && \
chmod +x create.sh && \
rm README.md && \
./create.sh
```
<a href="https://github.com/vdarkobar/DebianTemplate/blob/main/README.md#debian-template"> * </a>
  
---  
  
### Clone Debian server template, copy and run *commands* the to install *(one or more)* Services:
<br><br>

### *Unbound DNS (with optional Pi-Hole)*:
*VM*:
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/vdarkobar/unbound/main/setup.sh)"
```

*CT*:
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/vdarkobar/unbound/main/setup-ct.sh)"
```

<a href="https://github.com/vdarkobar/unbound/tree/main?tab=readme-ov-file#unbound"> * </a>
<br><br>
  
### *Samba file server*:
*VM*:
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/vdarkobar/Samba/main/setup.sh)"
```
*CT*:
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/vdarkobar/Samba/main/setup-ct.sh)"
```

<a href="https://github.com/vdarkobar/Samba/tree/main?tab=readme-ov-file#samba"> * </a>
<br><br>
  
### *Nginx Proxy Manager*:
```bash
clear
RED='\033[0;31m'; NC='\033[0m'; echo -ne "${RED}Enter directory name: ${NC}"; read DIR; mkdir -p "$DIR"; \
cd "$DIR" && git clone https://github.com/vdarkobar/NPM.git . && \
chmod +x setup.sh && \
./setup.sh
```

<a href="https://github.com/vdarkobar/NPM#nginx-proxy-manager"> * </a>
<br><br>
  
### *Nextcloud*:
```bash
clear
RED='\033[0;31m'; NC='\033[0m'; echo -ne "${RED}Enter directory name: ${NC}"; read NAME; mkdir -p "$NAME"; \
cd "$NAME" && git clone https://github.com/vdarkobar/Nextcloud.git . && \
chmod +x setup.sh && \
rm README.md && \
./setup.sh
```

<a href="https://github.com/vdarkobar/Nextcloud?tab=readme-ov-file#nextcloud"> * </a>
<br><br>

### *Nextcloud (Docker)*:
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

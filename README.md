  
---  
  
# *Self-hosted Home (Lab) Cloud*


<p align="center">
  <img src="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/infrastructure1.webp">
</p>
  
---  
  
## Add *domain* to <a href="https://dash.cloudflare.com/">CloudFlare</a> with the following settings:
  
<a href="https://support.cloudflare.com/hc/en-us/articles/201720164-Creating-a-Cloudflare-account-and-adding-a-website">*</a>

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
  
## *Install and Configure Proxmox Virtual Environment, create*:
  
<a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Proxmox.md#proxmox"> * </a>
<br><br>
  
### *Bastion/Jump Server*:
*VM/CT*:
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/vdarkobar/Bastion/main/setup.sh)"
```

<a href="https://github.com/vdarkobar/Bastion/blob/main/README.md#bastion"> * </a>
<br><br>
  
### *Debian server template*:
*VM*:
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/vdarkobar/DebianTemplate/main/test.sh)"
```

<a href="https://github.com/vdarkobar/DebianTemplate/blob/main/README.md#debian-template"> !!! </a>
  
---  
  
## Login using Bastion, run script to install Service:

  
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
*VM/CT*:
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/vdarkobar/Samba/main/setup-ct.sh)"
```

<a href="https://github.com/vdarkobar/Samba/tree/main?tab=readme-ov-file#samba"> * </a>
<br><br>
  
### *Nginx Proxy Manager (Docker)*:
*VM/CT*:
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/vdarkobar/NPM/main/setup.sh)"
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

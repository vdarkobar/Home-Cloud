  
---  
  
# *Self-hosted Home (Lab) Cloud*
  
<p align="center">
  <img src="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/infrastructure.webp">
</p>
    
---  

Create <a href="https://dash.cloudflare.com/sign-up">Cloudflare account</a> or login to <a href="https://dash.cloudflare.com/">CloudFlare</a> and add a website <a href="https://support.cloudflare.com/hc/en-us/articles/201720164-Creating-a-Cloudflare-account-and-adding-a-website">*</a> with the following settings:
  
<pre>
SSL/TLS Mode - Full (strict)  

Edge Certificates:  
  Always Use HTTPS: ON  
  HTTP Strict Transport Security (HSTS): Enable (Be Cautious)  
  Minimum TLS Version: 1.2  
  Opportunistic Encryption: ON  
  TLS 1.3: ON  
  Automatic HTTPS Rewrites: ON  
  Certificate Transparency Monitoring: ON   
  
Firewall Settings:  
  Security Level: High  
  Bot Fight Mode: ON  
  Challenge Passage: 30 Minutes  
  Browser Integrity Check: ON  
</pre>
<br><br>
### *Install and Configure Proxmox Virtual Environment*:
  
- follow for <a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Proxmox.md#proxmox">more info</a>
<br><br>
  
### *Bastion / Jump server VM*:
```
clear
sudo apt -y install git && \
RED='\033[0;31m'; NC='\033[0m'; echo -ne "${RED}Enter directory name: ${NC}"; read NAME; mkdir -p "$NAME"; \
cd "$NAME" && git clone https://github.com/vdarkobar/Bastion.git . && \
chmod +x create.sh && \
rm README.md && \
./create.sh
```
- follow for <a href="https://github.com/vdarkobar/Bastion/blob/main/README.md#bastion">more info</a>
<br><br>
  
### *Debian server template VM*:
```
clear
sudo apt -y install git && \
RED='\033[0;31m'; NC='\033[0m'; echo -ne "${RED}Enter directory name: ${NC}"; read NAME; mkdir -p "$NAME"; \
cd "$NAME" && git clone https://github.com/vdarkobar/DebianTemplate.git . && \
chmod +x create.sh && \
rm README.md && \
./create.sh
```
- follow for <a href="https://github.com/vdarkobar/DebianTemplate/blob/main/README.md#debian-template">more info</a>
<br><br>
  
### *Unbound DNS (optional Pi-Hole) VM*:
```
clear
sudo apt -y install git && \
RED='\033[0;31m'; NC='\033[0m'; echo -ne "${RED}Enter directory name: ${NC}"; read NAME; mkdir -p "$NAME"; \
cd "$NAME" && git clone https://github.com/vdarkobar/unbound.git . && \
chmod +x pihole-install.sh && \
chmod +x setup.sh && \
rm config-explained && \
rm README.md && \
rm steps.md && \
./setup.sh
```
- follow for <a href="https://github.com/vdarkobar/unbound/tree/main?tab=readme-ov-file#unbound">more info</a>
<br><br>
  
  
### Install Reverse Proxy:
  
  
<p align="left">
  <img src="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/npm.webp"> <a href="https://github.com/vdarkobar/NPM#nginx-proxy-manager">NginxProxyManager</a>  
</p>
  
---  
  
<p align="center">
  All set to add Services:
</p>

<p align="center">
   |  
  <a href="https://github.com/vdarkobar/Samba/tree/main?tab=readme-ov-file#samba">Samba File Server</a>  |
  <a href="https://github.com/vdarkobar/Nextcloud?tab=readme-ov-file#nextcloud">Nextcloud</a>  
  <br><br>
</p> 
  
<p align="center">
  Docker:
</p>
  
- Clone <a href="https://github.com/vdarkobar/DebianTemplate/blob/main/README.md#debian-template">Template</a> and install <a href="https://github.com/vdarkobar/Docker/blob/main/README.md#docker">Docker/Podman</a>, or create Template with Docker/Podman preinstalled
  <br><br>
  
<p align="center">
  <a href="https://github.com/vdarkobar/Vaultwarden?tab=readme-ov-file#vaultwarden">Vaultwarden</a> |  
  <a href="https://github.com/vdarkobar/Matrix">Matrix</a> |  
  <a href="https://github.com/vdarkobar/NC">NextCloud</a> |  
  <a href="https://github.com/vdarkobar/WP">WordPress</a> |  
  <a href="https://github.com/vdarkobar/Calibre-web">Calibre-web</a> |  
  <a href="https://github.com/vdarkobar/Authelia">Authelia</a>  
  <br><br>
</p>  
  
---  
  
  
<a href="https://github.com/vdarkobar/Home-Cloud/blob/main/README.md#self-hosted-cloud">top of the page</a>

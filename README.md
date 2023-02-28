  
---  
  
# *Self-hosted Cloud,*
  
<p align="center">
  <img src="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/infrastructure.webp">
</p>
  
<p align="center">
<i>using <a href="https://www.proxmox.com/">Proxmox</a>, <a href="https://www.debian.org/">Debian</a> and <a href="https://www.docker.com/">Docker</a> to run: 
</p>  
  
<p align="center">
  <a href="https://github.com/vdarkobar/NPM">NginxProxyManager</a> <a href="https://nginxproxymanager.com/">*</a> |  
  <a href="https://github.com/vdarkobar/Vaultwarden">Vaultwarden</a> <a href="https://github.com/dani-garcia/vaultwarden">*</a> |  
  <a href="https://github.com/vdarkobar/Matrix">Matrix</a> <a href="https://matrix.org/">*</a> |  
  <a href="https://github.com/vdarkobar/NC">NextCloud</a> <a href="https://nextcloud.com/">*</a> |  
  <a href="https://github.com/vdarkobar/WP">WordPress</a> <a href="https://wordpress.com/">*</a> |  
  <a href="https://github.com/vdarkobar/Calibre-web">Calibre-web</a> <a href="https://github.com/janeczku/calibre-web">*</a> |  
  <a href="https://github.com/vdarkobar/Authelia">Authelia</a> <a href="https://www.authelia.com/">*</a>  
  <br><br>
</p>  
  
---  
  
## Steps:
  
- Install and Configure <a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Proxmox.md">Proxmox VE</a>
  <br><br>
- Create and configure <a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Bastion.md">Bastion Server</a>
  <br><br>
- Create and configure <a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Debian.md">Debian Server Template</a>
  <br><br>
- Clone <a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Debian.md">Debian Server Template</a> and install <a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Docker.md">Docker</a>
  <br><br>
- Create <a href="https://dash.cloudflare.com/sign-up">Cloudflare account</a> or login to <a href="https://dash.cloudflare.com/">CloudFlare</a> and add a website <a href="https://support.cloudflare.com/hc/en-us/articles/201720164-Creating-a-Cloudflare-account-and-adding-a-website">*</a> with the following settings:
  
#### Site settings:  

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
  
- Choose a Reverse Proxy

<a href="https://github.com/vdarkobar/NPM">NginxProxyManager</a> <a href="https://nginxproxymanager.com/">*</a>  
  
<p>
  <img src="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/npm.png">
      align="left"
  <img src="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/npm.png">
      align="center"
</p>

<body>
    <img src=
"https://github.com/vdarkobar/Home-Cloud/blob/main/shared/npm.png"
        alt="testR"
        align="right">
    <img src=
"https://github.com/vdarkobar/Home-Cloud/blob/main/shared/npm.png"
        alt="testC"
        align="justify">
    <img src=
"https://github.com/vdarkobar/Home-Cloud/blob/main/shared/npm.png"
        alt="testL"
        align="left">
</body>


  
<p align="center">
<a href="https://github.com/vdarkobar/Home-Cloud#self-hosted-cloud">all set to add Services</a>
</p>
  
---  

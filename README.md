  
---  
  
#### *Self-hosted Cloud,*
<p align="center">
<i>using <a href="https://www.cloudflare.com/products/tunnel/">Cloudflare Argo Tunnels</a> with <a href="https://www.proxmox.com/">Proxmox</a>, <a href="https://www.debian.org/">Debian</a> and <a href="https://www.docker.com/">Docker</a> to run: 
</p>    
  
<p align="center">
  <a href="https://github.com/vdarkobar/NPM">NginxProxyManager</a> |
  <a href="https://github.com/vdarkobar/Authelia">Authelia</a> |
  <a href="https://github.com/vdarkobar/Vaultwarden">Vaultwarden</a> |  
  <a href="https://github.com/vdarkobar/NC">NextCloud</a> |  
  <a href="https://github.com/vdarkobar/WP">WordPress</a> |  
  <a href="https://github.com/vdarkobar/Calibre-web">Calibre-web</a> |  
  <br><br>
</p>  
  
with added security of not needing to open *Ports* in your *Firewall*, also fixing *Double NAT* situations.
  
---  
    
Login to <a href="https://dash.cloudflare.com/">CloudFlare</a>, <a href="https://support.cloudflare.com/hc/en-us/articles/201720164-Creating-a-Cloudflare-account-and-adding-a-website">add a website</a> with the following settings:

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


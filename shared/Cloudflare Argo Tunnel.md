 <p align="left">
  <a href="https://github.com/vdarkobar/Home-Cloud#self-hosted-cloud">Home</a>
</p>  
  
# Cloudflared
  
---

<a href="https://www.cloudflare.com/products/tunnel/">Cloudflare Argo Tunnels</a> <a href="https://blog.cloudflare.com/argo-tunnels-that-live-forever/">*</a>

Login to <a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Debian.md">Debian Server</a>, and add *CloudFlare* repository
```
sudo echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/ buster main' |
sudo tee /etc/apt/sources.list.d/cloudflare-main.list

sudo curl https://pkg.cloudflare.com/cloudflare-main.gpg -o /usr/share/keyrings/cloudflare-main.gpg
```
Update and install cloudflared
```
sudo apt update
sudo apt install cloudflared
```

Login and create tunnel (*it will pool CF certificate*)
```
cloudflared login
```
```
cloudflared tunnel create <name>
```

Check if cert.pem file is there
```
ls .cloudflared
```

Setting up your DNS records:  
  
Create DNS record from the commandline
*If already exists, delete your A record (A | example.com | YOUR WAN IP)*
```
cloudflared tunnel route dns <UUID or NAME> example.com
(cloudflared tunnel route dns <UUID or NAME> www.example.com)
```
  
`To create DNS record manually (no need):  
Create CNAME record that points to the tunnel UUID (append *.cfargotunnel.com*)  
CNAME | example.com | UUID.cfargotunnel.com`
  
Create configuration file 
```
sudo nano .cloudflared/config.yml
```
with the following content:
```
tunnel: UUID
credentials-file: /home/<user>/.cloudflared/UUID.json

ingress:
  - hostname: "*.example.com"
    service: http://<NPM-IP-WITHOUT-PORT-NUMMBER>   # test it with port nummber (80,443)
  - service: http_status:404

logfile: /var/log/cloudflared.log
```
  
Run as as Service (*persistent across reboots*):
  
Create the Cloudflared directory (if it doesn't exist)
```
sudo mkdir -p /etc/cloudflared
```
Copy Argo certificate into /etc/cloudflared directory
```
sudo cp ~/.cloudflared/cert.pem /etc/cloudflared
```

Install
```
sudo cloudflared --config /home/darko/.cloudflared/config.yml service install
```

Enable on startup and start, run together:
```
sudo systemctl enable cloudflared && \
sudo systemctl start cloudflared && \
sudo systemctl status cloudflared
```
  
After creating or modifying any unit files, reload systemd:
```
sudo systemctl restart cloudflared
sudo systemctl daemon-reload
```

To revoke and delete a Tunnel
```
#To delete a Tunnel, run the following command:
cloudflared tunnel delete <NAME>
```

If there are still active connections on that Tunnel, then you will have to force the deletion with:
```
cloudflared tunnel delete -f <NAME>
```
  
Test it with docker:
```
sudo docker run -it --rm -d -p 8187:80 --name web1 nginx && \
sudo docker run -it --rm -d -p 8188:80 --name web2 httpd
```
  
NPM Interface > Add Proxy Host, pointing to Docker test service at `http://Server-IP:8187`, `http://Server-IP:8188`  
Enable SSL: NPM Interface > Proxy Host > SSL, without additional options.  
  
Visit > *test.example.com*
  
---
  
Forwarding network trafic directly to Services (no Reverse Proxy)
  
*If already exists, delete your CNAME record that points to the tunnel UUID, (CNAME | example.com | UUID.cfargotunnel.com)*
  
Create tunnel
  
Create CNAME record for Subdomains that points to the UUID
```
cloudflared tunnel route dns <UUID or NAME> test1.example.com
cloudflared tunnel route dns <UUID or NAME> test2.example.com
```
result
```
CNAME | test1 | <TunnelID>.cfargotunnel.com
CNAME | test2 | <TunnelID>.cfargotunnel.com
```
  
Create configuration file 
```
sudo nano .cloudflared/config.yml
```
  
with the following content:
```
tunnel: UUID
credentials-file: /home/<user>/.cloudflared/UUID.json

ingress:
    # Service 01
  - hostname: test1.example.com
    service: http://<IP>:8187
    # Service 02
  - hostname: test2.example.com
    service: http://<IP>:8188
    # Catch-all
  - service: http_status:404

logfile: /var/log/cloudflared.log
```
  
Run tunnel  
Test it with docker
  
--- 
 
<p align="center">
<a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Cloudflare%20Argo%20Tunnel.md#cloudflared">back to top</a>
</p>

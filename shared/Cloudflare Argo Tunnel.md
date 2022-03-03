 <p align="left">
  <a href="https://github.com/vdarkobar/Home-Cloud#self-hosted-cloud">Home</a>
</p>  
  
# Cloudflared
  
---
  
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
cloudflared tunnel create <name>
```

Check if cert.pem file is there
```
ls /.cloudflared
```

Setting up your DNS records:  
  
create DNS record from the commandline
```
cloudflared tunnel route dns <UUID or NAME> example.com
(cloudflared tunnel route dns <UUID or NAME> www.example.com)
```
To create DNS record manually:  
If exists, delete your A record that points to the domain root (@)  
Create CNAME record that points to the tunnel UUID (append *.cfargotunnel.com*)  
CNAME | @ | UUID.cfargotunnel.com 
  
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
    service: http://<NPM-IP-WITHOUT-PORT-NUMMBER>   # test with port nummber
  - service: http_status:404

logfile: /var/log/cloudflared.log
```
  
Run as as Service:
  
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
create CNAME record for Subdomains that points to the UUID (append *.cfargotunnel.com*)
```
CNAME | test1 | <TunnelID>.cfargotunnel.com
CNAME | test2 | <TunnelID>.cfargotunnel.com
```
  
NPM Interface > Add Proxy Host, pointing to Docker test service at `http://Server-IP:8187`  
Enable SSL: NPM Interface > Proxy Host > SSL, without additional options.  
  
Visit > *test.example.com*
  
<p align="center">
<a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Cloudflare%20Argo%20Tunnel.md#cloudflared">back to top</a>
</p>

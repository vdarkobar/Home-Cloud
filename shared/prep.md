#cloudflared

Add repo
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

#login and create tunnel (it will pool CF certificate)
```
cloudflared login
cloudflared tunnel create <name>
```

#check if cert.pem file is there
```
ls /.cloudflared
```

#Setting up your DNS records
##Delete your A record that points to the domain root (@)
##Create CNAME record that points to the UUID (append .cfargotunnel.com)
##CNAME | @ | UUID.cfargotunnel.com
#or:
#crate DNS record from the commandline
```
cloudflared tunnel route dns <UUID or NAME> www.example.com
```

#Create CNAME record, that points to the domain root (@) and for the content, 
#you need to add UUID.cfargotunnel.com (inserting your UUID that was copied earlier).


#create configuration file 
```
sudo nano .cloudflared/config.yml
```
```
tunnel: UUID
credentials-file: /home/<user>/.cloudflared/UUID.json

ingress:
  - hostname: "*.example.com"
    service: http://<NPM-IP>
  - service: http_status:404

logfile: /var/log/cloudflared.log
```

#Run as as Service:

# Create the cloudflared directory if not exist
```
mkdir -p /etc/cloudflared
```
# Copy Argo certificate into /etc/cloudflared directory
```
sudo cp ~/.cloudflared/cert.pem /etc/cloudflared
```

#Install
```
sudo cloudflared --config /home/darko/.cloudflared/config.yml service install
```

#Enable on startup and start, run together:
```
sudo systemctl enable cloudflared && \
sudo systemctl start cloudflared && \
sudo systemctl status cloudflared
```
#After creating or modifying any unit files, reload systemd:
```
sudo systemctl restart cloudflared
sudo systemctl daemon-reload
```

#Revoke and delete a Tunnel
```
#To delete a Tunnel, run the following command:
cloudflared tunnel delete <NAME>
```

#If there are still active connections on that Tunnel, then you will have to force the deletion with:
```
cloudflared tunnel delete -f <NAME>
```
#test with docker
```
sudo docker run -it --rm -d -p 8187:80 --name web nginx
```

#Create CNAME record for Subdomain that points to the UUID (append .cfargotunnel.com)
```
#CNAME | test | @
```

#NPM Interface > create new Proxy Host pointing to Docker test service http://<IP>:8187
#Enable SSL (NPM > Proxy Host > SSL) without additional options.

#Visit > test.example.com
<p align="left">
  <a href="https://github.com/vdarkobar/home-cloud">Home</a>
  <br><br>
</p> 
  
#### *Decide what you will use for*:
```
Time Zone nad NPM Port Number.
```
  
### *Run this command*:
```
cd npm && \
chmod +x setup.sh && \
./setup.sh
```
  
Visit your *server local ip* + *port* designated during setup:
```
http://<LocalIP>:<PORT>
```

### Create <a href="https://dash.cloudflare.com/profile/api-tokens">CloudFlare API Token</a>. 

Used for *DNS Challenge* to create *Wildcard Certificates* for your services.
```
CloudFlare > Profile > API Tokens > Edit zone DNS - Template
Create Token (edit name: *.example.com) > 
Permissions: Zone-DNS-EDIT > Zone Resources: INCLUDE-ALL ZONES > Continue to summary > Create Token
```
Copy *Token* and paste it to:
```
Nginx Proxy Manager > SSL Certificates > Add SSL Certificate > Let's Encrypt > Domain Names (enter: *.example.com example.com) 

Enable: Use a DNS Challenge > CloudFlare > Credentials File Content * (paste Token after = sign).
```

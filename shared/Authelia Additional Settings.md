<p align="left">
  <a href="https://github.com/vdarkobar/Authelia">Authelia</a>
  <br><br>
</p> 
  
- Applies when Authelia and Protected Endpoints are on the same Docker Host/Server.  
- If Authelia and Protected Endpoints are on the different Docker Host/Server use <a href="https://github.com/vdarkobar/NPM/blob/main/shared/Different%20Endpoint.md">this</a> example.
  
Change/Adjust:
```
- Container names
- IP:PORT combinations
- Subdomain.Domain name combinations
- Network IP Range and Subnet mask
```
  
After editing *configuration.yml*, for Authelia settings to apply, run:
```
sudo docker-compose restart
```
  
### *Copy Custom Nginx Configuration to*:
```
Nginx Proxy Manager > Proxy Hosts > Edit > Advanced > Custom Nginx Configuration
```
  
Auth Subdomain (auth.example.com)
```
location / {
set $upstream_authelia http://IP:PORT; #Change to match your Authelia Container name and Server IP:PORT
proxy_pass $upstream_authelia;
client_body_buffer_size 128k;

#Timeout if the real server is dead
proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;

# Advanced Proxy Config
send_timeout 5m;
proxy_read_timeout 360;
proxy_send_timeout 360;
proxy_connect_timeout 360;

# Basic Proxy Config
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Forwarded-Host $http_host;
proxy_set_header X-Forwarded-Uri $request_uri;
proxy_set_header X-Forwarded-Ssl on;
proxy_redirect  http://  $scheme://;
proxy_http_version 1.1;
proxy_set_header Connection "";
proxy_cache_bypass $cookie_session;
proxy_no_cache $cookie_session;
proxy_buffers 64 256k;

# Assumes you're using Cloudflare.
set_real_ip_from 192.168.1.0/24; #Make sure this IP range matches your network setup.
real_ip_header CF-Connecting-IP;
real_ip_recursive on;
}
```
  
Protected Endpoint (blog.example.com, wiki.example.com, ...)
```
location /authelia {
internal;
set $upstream_authelia http://IP:PORT/api/verify; #Change to match your Authelia Container name and Server IP:PORT
proxy_pass_request_body off;
proxy_pass $upstream_authelia;    
proxy_set_header Content-Length "";

# Timeout if the real server is dead
proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;
client_body_buffer_size 128k;
proxy_set_header Host $host;
proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $remote_addr; 
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Forwarded-Host $http_host;
proxy_set_header X-Forwarded-Uri $request_uri;
proxy_set_header X-Forwarded-Ssl on;
proxy_redirect  http://  $scheme://;
proxy_http_version 1.1;
proxy_set_header Connection "";
proxy_cache_bypass $cookie_session;
proxy_no_cache $cookie_session;
proxy_buffers 4 32k;

send_timeout 5m;
proxy_read_timeout 240;
proxy_send_timeout 240;
proxy_connect_timeout 240;
}

location / {
set $upstream_CONTAINERNAME $forward_scheme://$server:$port; # Adjust container name.
proxy_pass $upstream_CONTAINERNAME; # Adjust container name

auth_request /authelia;
auth_request_set $target_url https://$http_host$request_uri;
auth_request_set $user $upstream_http_remote_user;
auth_request_set $email $upstream_http_remote_email;
auth_request_set $groups $upstream_http_remote_groups;
proxy_set_header Remote-User $user;
proxy_set_header Remote-Email $email;
proxy_set_header Remote-Groups $groups;

error_page 401 =302 https://auth.example.com/?rd=$target_url; #Change this to match your Authelia subdomain.domain

client_body_buffer_size 128k;

proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;

send_timeout 5m;
proxy_read_timeout 360;
proxy_send_timeout 360;
proxy_connect_timeout 360;

proxy_set_header Host $host;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection upgrade;
proxy_set_header Accept-Encoding gzip;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Forwarded-Host $http_host;
proxy_set_header X-Forwarded-Uri $request_uri;
proxy_set_header X-Forwarded-Ssl on;
proxy_redirect  http://  $scheme://;
proxy_http_version 1.1;
proxy_set_header Connection "";
proxy_cache_bypass $cookie_session;
proxy_no_cache $cookie_session;
proxy_buffers 64 256k;

set_real_ip_from 192.168.1.0/24; #Make sure this matches your network setup.
real_ip_header CF-Connecting-IP;
real_ip_recursive on;

}
```

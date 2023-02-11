<p align="left">
  <a href="https://github.com/vdarkobar/Home-Cloud#self-hosted-cloud">Home</a>
</p>   
  
# Docker
## *Install Docker and Docker compose*
  
--- 
  
Add free space to Cloned VM: *VM > Hardware > Hard Disk > Resize disk*  

--- 
  
### Docker:
```
sudo mkdir -p /etc/apt/keyrings
```
```
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```
```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
```
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo docker --version && docker compose version
```
```
sudo docker --version && docker compose version
```
  
### Securing Docker:  

<p align="center">
  <b>Do not add user to docker group (sudo usermod -aG docker $USER && logout).</b><br>
  <b>Do not mess with the ownership of Docker Socket (/var/run/docker.sock in Linux)</b><br>
  <b>Change DOCKER_OPTS to Respect IP Table Firewall. Add the following line:</b><br>
</p>

```
sudo nano /etc/default/docker
#
DOCKER_OPTS="--iptables=false"  
```
  
### Test:
```
docker run --name mynginx1 -p 80:80 -d nginx 
```

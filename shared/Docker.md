<p align="left">
  <a href="https://github.com/vdarkobar/Home-Cloud">Home</a>
</p>   
  
# Docker
## *Install Docker and Docker compose*
  
--- 
  
Add free space to Cloned VM: *VM > Hardware > Hard Disk > Resize disk*  

--- 
  
### Docker:
```
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
```
```
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/debian \
  $(lsb_release -cs) \
  stable"
```
```
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo docker -v
```
  
### Docker Compose:  
  
[Check the current Docker Compose release here](https://github.com/docker/compose/releases):
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose  
sudo chmod +x /usr/local/bin/docker-compose
sudo docker-compose --version
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

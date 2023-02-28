<p align="left">
  <a href="https://github.com/vdarkobar/Home-Cloud#self-hosted-cloud">Home</a>
</p>   
  
# Docker
## *Install Docker and Docker compose*
  
--- 
  
### Add free space to cloned VM:  
> *VM Name > Hardware > Hard Disk > Disk Action > Resize*  
  
  
### Docker:
```bash
sudo mkdir -p /etc/apt/keyrings
```
```bash
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```
```bash
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```
```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
```bash
sudo apt update && \
sudo apt install -y \
  docker-ce docker-ce-cli \
  containerd.io \
  docker-compose-plugin
```
  
Test:
```bash
sudo docker --version && docker compose version
```
```bash
sudo systemctl status docker containerd
```
```bash
sudo systemctl is-enabled docker && \
sudo systemctl is-enabled containerd
```
```bash
sudo systemctl enable docker.service && \
sudo systemctl enable containerd.service
```
```bash
sudo docker run hello-world
```
```bash
sudo docker run --name mynginx1 -p 80:80 -d nginx 
```
  
#### *Securing Docker:*  

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

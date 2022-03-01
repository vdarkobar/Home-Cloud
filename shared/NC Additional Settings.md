<p align="left">
  <a href="https://github.com/vdarkobar/NC">NextCloud</a>
  <br><br>
</p> 
  
#### Edit *config.php* file:
```
sudo nano /home/<USER>/<NextCloudFolder>/files/config/config.php
```  
  
 Slow login, edit: *'overwrite.cli.url' => ...*
```
# change to (if using domain name):
'overwrite.cli.url' => 'https://example.com', 'overwritehost' => 'example.com', 'overwriteprotocol' => 'https',
#or
'overwrite.cli.url' => 'https://example.com', 
'overwritehost' => 'example.com', 
'overwriteprotocol' => 'https',
```
```
# or (if using subdomain):
'overwrite.cli.url' => 'https://subdomain.example.com', 'overwritehost' => 'subdomain.example.com', 'overwriteprotocol' => 'https',
# or:
'overwrite.cli.url' => 'https://cloud.home-network.me',
'overwritehost' => 'cloud.home-network.me',
'overwriteprotocol' => 'https',

```
Default landing app after login, add at the end:
```
'defaultapp' => 'files',
# ...
  'installed' => true,
  'instanceid' => 'ocjoficzuewq',
  'defaultapp' => 'files', # << added here
);
```
  
#### *Collabora* - Document Server:  

Log in and install *Collabora Online* app:
```
https://<NextCloud> > Account > Apps > Collabora Online
```

Connect *Collabora Online* app with the Server:  
```
https://<NextCloud> > Account > Settings > Collabora Online Development Edition
```

Enter *Collabora* - Document Server url (*no Port Number needed*):
  
<p align="center">
  <img src="https://github.com/vdarkobar/NPM/blob/main/shared/Collabora.webp">
</p>

Colabora Admin interface (username admin):
```
https://yourdomain.tld/loleaflet/dist/admin/admin.html
```
  
#### Setup SMTP server for gmail (use App-passwords option if 2fa is enabled on the account):
  
<p align="center">
  <img src="https://github.com/vdarkobar/NPM/blob/main/shared/smtp.webp">
</p>

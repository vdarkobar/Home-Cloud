<p align="left">
  <a href="https://github.com/vdarkobar/WP">WordPress</a>
  <br><br>
</p> 
  
#### File upload limit:
```
sudo nano html/.htaccess
```
##### *add:*
```
php_value upload_max_filesize 128M
php_value post_max_size 128M
php_value max_execution_time 300
php_value max_input_time 300
```
  
There are two database images you can choose from, MySQL:5.7 or MariaDB. As the password authentication method changed in MySQL 8, 
if you really want to use MySQL, choose version 5.7 or you need extra command listed below.
```
image: mysql:8
command: '--default-authentication-plugin=mysql_native_password'
```

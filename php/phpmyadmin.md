
# Nginx & phpMyadmin

## install php
```
sudo apt-get install php
```

## install php-fpm
```
sudo apt-get install php-fpm
```

## modify  /etc/nginx/sites-avalible/default
```
server {
        #listen 8081 default_server;
        #listen [::]:8081 default_server;
        
        #https begin
        listen 443 ssl default_server;
        listen [::]:443 ssl default_server;
        include snippets/snakeoil.conf;
        #https end
        
        root /var/www/html;

        index  index.php;

        server_name _;

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.0-fpm.sock;
                fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
        }
}
```
### add /var/www/html/phpmyadmin link to /usr/share/phpmyadmin
```
XXXX@XXXX:/var/www/html$ ls
index.html  index.nginx-debian.html  phpmyadmin
dragon@dragon:/var/www/html$ ls -all -t
drwxr-xr-x 2 root root  4096 11月 21 02:29 .
lrwxrwxrwx 1 root root    21 11月 21 02:29 phpmyadmin -> /usr/share/phpmyadmin
-rw-r--r-- 1 root root 11321 11月 21 02:24 index.html
-rw-r--r-- 1 root root   612 11月  9 07:39 index.nginx-debian.html
drwxr-xr-x 3 root root  4096 11月  9 07:39 ..
dragon@dragon:/var/www/html$


```

### config.inc.php
```
XXX@XXXn:/usr/share/phpmyadmin$sudo cp  config.sample.inc.php  config.inc.php
```

## https://127.0.0.1/phpmyadmin
username and password equals to mysql 's username and passward



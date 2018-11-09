
# Nginx & phpMyadmin

```shell
:/etc/nginx$ ls
conf.d        fastcgi_params  koi-win     nginx.conf  proxy_params  sites-available  snippets      win-utf
fastcgi.conf  koi-utf         mime.types  phpmyadmin  scgi_params   sites-enabled    uwsgi_params
XXX@XXX:/etc/nginx$ cat phpmyadmin
location /phpMyAdmin {
    alias /usr/share/phpMyAdmin;
    index index.php;

    location ~ ^/phpMyAdmin/.+\.php$ {
        alias /usr/share/phpMyAdmin;
        fastcgi_pass   phpfpm;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME /usr/share$fastcgi_script_name;
        include        fastcgi_params;
    }
}
```

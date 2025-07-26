### Ansible Role: Nginx

Эта роль устанавливает и настраивает последнюю версию Nginx из официального репозитория на системах, основанных на RedHat.

### Variables

Доступные переменные со значениями по умолчанию (см. defaults/main.yml)

Шаблоны конфиуграции в `./templates/nginx.conf.j2; ./templates/vhost.j2` 

Пример переменных для настройки vhosts:

```yaml
nginx_vhosts:
  - server_name: "localhost"
    listen: "80"
    access_log: "False"
    error_log: "False"
    extra_options: |-
      error_page   500 502 503 504  /50x.html;
    location:
      - name: /
        location_options: |-
          root   /usr/share/nginx/html;
          index  index.html index.htm;
      - name: = /50x.html
        location_options: |-
          root   /usr/share/nginx/html;

  - server_name: "standart.it-connector.ru"
    proxy_server: "localhost:8113"
    listen: "443 ssl"

  - server_name: "rabbitmq-manage.it-connector.ru"
    proxy_server: "localhost:15672"
    listen: "443 ssl"
    extra_options: |-
      allow 5.167.76.63;
      deny all;

  - server_name: "online-consult.it-connector.ru"
    proxy_server: "localhost:7001"
    listen: "443 ssl"
    location:
      - name: /admin/login
        location_options: |-
          allow 5.167.76.63;
          deny all;
          proxy_pass http://localhost:7001/admin/login;
      - name: /static
        location_options: |-
          root /opt/online_consult/static;

  - server_name: "it-partner.ksb-server"
    listen: "80"
    proxy_server: "localhost:9900"
    access_log: "False"
    location:
      - name: /ws
        location_options: |-
          proxy_pass  http://localhost:9900;

  - server_name: "partner.npc-ksb.ru"
    listen: "443 ssl"
    proxy_server: "localhost:9901"
    #redirect settings 
    extra_server: |-
      listen 443 ssl;
      server_name partner.it-connector.ru;
      location / {
          return 301 http://partner.npc-ksb.ru$request_uri;
      }          
```
По умолчанию включена запись логов в /var/log/nginx/
Чтобы отключить, нужно добваить переменную `error_log: "False"` -  для error_log или  `access_log: "False"` - для access_log

Дополнительные строки для вставки в блок server на верхнем уровне в vhost.conf. Значение должно быть определено буквально (как вы вставили бы его непосредственно в vhost.conf, соблюдая синтаксис конфигурации Nginx, такой как для завершения строки и т.д.), например:

```yaml
extra_options: |-
set_real_ip_from 10.38.20.245;
real_ip_header X-Forwarded-For;
allow 5.167.76.63;
deny all;
```

Пример настрйоки проксирования веб сервера:

```yaml
- server_name: "standart.it-connector.ru"
  proxy_server: "localhost:8113"
  listen: "443 ssl"    
```

Так же можно доабвить дополнительные блоки location: 

```yaml
- server_name: "online-consult.it-connector.ru"
  proxy_server: "localhost:7001"
  listen: "443 ssl" 
  location: 
    - name: /admin/login
      location_options: |- 
        allow 5.167.76.63;
        deny all;
        proxy_pass http://localhost:7001/admin/login;
    - name: /static 
      location_options: |-
        root /opt/online_consult/static;
```         

location_options добавляет дополнительные строки в блок location. Значение должно быть определено буквально (как вы вставили бы его непосредственно в vhost.conf, соблюдая синтаксис конфигурации Nginx, такой как для завершения строки и т.д.)

Пример плейбука 

```yaml
- name: Install nginx 
  hosts: nginx
  become: yes 
  vars:
    - server_name: "online-consult.it-connector.ru"
    proxy_server: "localhost:7001"
    listen: "443 ssl" 
    location: 
      - name: /admin/login
        location_options: |- 
          allow 5.167.76.63;
          deny all;
          proxy_pass http://localhost:7001/admin/login;
      - name: /static 
        location_options: |-
          root /opt/online_consult/static;
  roles: 
    - ./roles/nginx
```
### Ansible Role: Postgres

Эта роль устанавливает и настраивает Postgres из официального репозитория на системах, основанных на RedHat.

### Variables

Доступные переменные со значениями по умолчанию (см. defaults/main.yml)

Библиотека, используемая Ansible для связи с PostgreSQL. Для Python 3 (например, установленный через ansible_python_interpreter), следует изменить это на python3-psycopg2

```yaml
postgresql_python_library: python-psycopg2
```

Директории, где будет создан сокет PostgreSQL

```yaml
postgresql_unix_socket_directories:
  - /var/run/postgresql
```

Глобальные опции, которые будут установлены в `postgresql.conf`

```yaml
postgresql_global_config_options:
  - option: port
    value: '5433'
  - option: listen_addresses
    value: '*'
  - option: log_directory
    value: '/vat/log/postgres'
```

Конфигурация файла [pg_hba.conf](https://www.postgresql.org/docs/current/static/auth-pg-hba-conf.html)

```yaml
postgresql_hba_entries:
  - { type: local, database: all, user: postgres, auth_method: peer }
  - { type: local, database: all, user: all, auth_method: peer }
  - { type: host, database: all, user: all, address: '127.0.0.1/32', auth_method: md5 }
  - { type: host, database: all, user: all, address: '::1/128', auth_method: md5 }
```

Список баз данных, которые необходимо создать на сервере. Обязательно только свойство name. Все остальные параметры являются необязательными

```yaml
postgresql_databases:
  - name: exampledb # required; the rest are optional
    lc_collate: # defaults to 'en_US.UTF-8'
    lc_ctype: # defaults to 'en_US.UTF-8'
    encoding: # defaults to 'UTF-8'
    template: # defaults to 'template0'
    login_host: # defaults to 'localhost'
    login_password: # defaults to not set
    login_user: # defaults to 'postgresql_user'
    login_unix_socket: # defaults to 1st of postgresql_unix_socket_directories
    port: # defaults to not set
    owner: # defaults to postgresql_user
    state: # defaults to 'present'
```

Список пользователей, которые должны быть созданы на сервере. Обязательно только свойство name. Все остальные параметры являются необязательными

```yaml
postgresql_users:
  - name: user #required; the rest are optional
    password: # defaults to not set
    encrypted: # defaults to not set
    priv: # defaults to not set
    role_attr_flags: # defaults to not set
    db: # defaults to not set
    login_host: # defaults to 'localhost'
    login_password: # defaults to not set
    login_user: # defaults to '{{ postgresql_user }}'
    login_unix_socket: # defaults to 1st of postgresql_unix_socket_directories
    port: # defaults to not set
    state: # defaults to 'present'
```

Эта перемення определяет, будет ли отображаться в консоли информация о пользователях (которая может содержать конфиденциальные данные, такие как пароли)

```yaml
postgresql_users_no_log: true
```
Пример плейбука:

```yaml
- name: Install postgres
  hosts: postgres
  become: yes
  vars:
    postgresql_global_config_options:
      - option: port
        value: '5432'
      - option: listen_addresses
        value: '*'
    postgresql_users:
      - name: ksb
        password: pass
        role_attr_flags: 'SUPERUSER,CREATEDB,CREATEROLE'
    postgresql_databases:
      - name: it_connector
        encoding: UTF-8
        template: template0
        owner: ksb
  roles:
    - ./roles/postgresql
```
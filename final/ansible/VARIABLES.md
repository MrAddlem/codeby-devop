В Ansible переменные можно хранить в различных местах, и они могут быть определены на нескольких уровнях. Вот основные способы и места хранения переменных в Ansible:

### 1. Переменные в `playbook`
Переменные могут быть объявлены непосредственно в playbook. Это удобно для небольших проектов или специфичных задач.

Пример:
```yaml
- hosts: webservers
  vars:
    apache_port: 80
  tasks:
    - name: Убедиться, что Apache установлен
      apt:
        name: apache2
        state: present

    - name: Убедиться, что Apache запущен
      service:
        name: apache2
        state: started
```

### 2. Переменные в `inventory`
В инвентарных файлах можно определить переменные для хостов и групп хостов.

Пример INI формата:
```ini
[webservers]
web1.example.com ansible_user=your_user apache_port=80
web2.example.com ansible_user=your_user apache_port=8080

[dbservers]
db1.example.com ansible_user=your_user
db2.example.com ansible_user=your_user
```

Пример YAML формата:
```yaml
all:
  hosts:
    web1.example.com:
      ansible_user: your_user
      apache_port: 80
    web2.example.com:
      ansible_user: your_user
      apache_port: 8080
  children:
    dbservers:
      hosts:
        db1.example.com:
          ansible_user: your_user
        db2.example.com:
          ansible_user: your_user
```

### 3. Переменные в `group_vars` и `host_vars`
Для групп хостов и отдельных хостов можно использовать каталоги `group_vars` и `host_vars` соответственно.

#### Пример для `group_vars/webservers.yml`:
```yaml
apache_port: 80
```

#### Пример для `host_vars/web1.example.com.yml`:
```yaml
apache_port: 80
```

### 4. Переменные в ролях
Внутри ролей переменные можно определить в нескольких местах:

#### `defaults/main.yml`
Переменные по умолчанию, которые могут быть переопределены другими переменными. Они имеют самый низкий приоритет.

Пример:
```yaml
---
apache_port: 80
```

#### `vars/main.yml`
Переменные роли, которые имеют более высокий приоритет и не могут быть переопределены другими переменными.

Пример:
```yaml
---
apache_port: 8080
```

### 5. Переменные командной строки
При запуске playbook можно передавать переменные через командную строку с помощью флага `-e`.

Пример:
```bash
ansible-playbook playbook.yml -e "apache_port=80"
```

### 6. Переменные в `ansible.cfg`
Некоторые переменные, такие как параметры подключения, могут быть заданы в конфигурационном файле Ansible (`ansible.cfg`).

Пример:
```ini
[defaults]
remote_user = your_user
```

### 7. Переменные в виде файлов YAML или JSON
Переменные можно хранить в отдельных файлах и включать их в playbook с помощью директивы `vars_files`.

Пример:
#### Файл `vars/apache.yml`:
```yaml
apache_port: 80
```

#### Playbook:
```yaml
- hosts: webservers
  vars_files:
    - vars/apache.yml
  tasks:
    - name: Убедиться, что Apache установлен
      apt:
        name: apache2
        state: present
```

### Пример структуры хранения переменных
```
project/
├── ansible.cfg
├── inventory
│   ├── hosts
├── playbook.yml
├── roles/
│   └── webserver/
│       ├── defaults/
│       │   └── main.yml
│       ├── vars/
│       │   └── main.yml
│       ├── tasks/
│       │   └── main.yml
├── group_vars/
│   └── webservers.yml
└── host_vars/
    └── web1.example.com.yml
```

Эта структура позволяет гибко управлять переменными на различных уровнях, облегчая настройку и управление конфигурациями.
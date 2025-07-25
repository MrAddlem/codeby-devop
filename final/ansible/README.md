Ansible — это инструмент для автоматизации управления конфигурациями, развёртывания приложений и других задач системного администрирования. Он использует простой синтаксис на языке YAML для описания автоматизируемых действий.

Вот краткое описание основных файлов и каталогов, используемых в Ansible:

### 1. `inventory`
Это файл или набор файлов, в которых указаны узлы (хосты), управляемые Ansible. Может быть в формате INI, YAML или JSON.

Пример INI формата:
```ini
[webservers]
web1.example.com
web2.example.com

[dbservers]
db1.example.com
db2.example.com
```

Пример YAML формата:
```yaml
all:
  hosts:
    web1.example.com:
    web2.example.com:
  children:
    dbservers:
      hosts:
        db1.example.com:
        db2.example.com:
```

### 2. `ansible.cfg`
Конфигурационный файл Ansible. В нём можно указать различные настройки, такие как расположение инвентарного файла, параметры подключения и т.д.

Пример:
```ini
[defaults]
inventory = ./inventory
remote_user = your_user
host_key_checking = False
```

### 3. `playbook.yml`
Основной файл, содержащий задачи, которые Ansible выполнит на удалённых узлах. Это список задач, написанных в формате YAML.

Пример:
```yaml
- hosts: webservers
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

### 4. `roles/`
Каталог для организации и многократного использования задач. Каждая роль содержит набор стандартных подкаталогов, таких как `tasks/`, `handlers/`, `files/`, `templates/`, `vars/`, `defaults/`, и `meta/`.

Пример структуры роли:
```
roles/
└── webserver
    ├── tasks
    │   └── main.yml
    ├── handlers
    │   └── main.yml
    ├── templates
    │   └── httpd.conf.j2
    ├── files
    ├── vars
    │   └── main.yml
    ├── defaults
    │   └── main.yml
    └── meta
        └── main.yml
```

### 5. `group_vars/` и `host_vars/`
Каталоги для хранения переменных, связанных с группами хостов и отдельными хостами соответственно. Файлы в этих каталогах также в формате YAML.

Пример для `group_vars/webservers`:
```yaml
apache_port: 80
```

### 6. `modules/`
Каталог, где могут храниться пользовательские модули Ansible.

### 7. `library/`
Каталог для собственных модулей, если они не размещены в стандартном месте.

### 8. `plugins/`
Каталог для собственных плагинов, таких как инвентарные плагины, фильтры и экшены.

### Пример структуры проекта
```
project/
├── ansible.cfg
├── inventory
├── playbook.yml
├── roles/
│   └── webserver/
│       ├── tasks/
│       │   └── main.yml
│       ├── handlers/
│       │   └── main.yml
│       ├── templates/
│       │   └── httpd.conf.j2
│       ├── files/
│       ├── vars/
│       │   └── main.yml
│       ├── defaults/
│       │   └── main.yml
│       └── meta/
│           └── main.yml
└── group_vars/
    └── webservers.yml
```

Эта структура обеспечивает чёткость и организованность, облегчая разработку, тестирование и поддержку ваших автоматизационных сценариев.
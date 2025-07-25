### Ansible Role: Docker

Эта роль устанавливает и настраивает последнюю версию Docker из официального репозитория на системах, основанных на RedHat.

### Variables

Доступные переменные со значениями по умолчанию (см. defaults/main.yml)

Список пользователей для доавления в группу docker

```yaml
docker_users:
  - ansible
  - ksb
```

Пользовательские настройки dockerd (файла /etc/docker/daemon.json )

```yaml
docker_daemon_options:
  storage-driver: "overlay2"
  log-opts:
    max-size: "25m"
    max-file: "5"
    compress: "true"
  registry-mirrors:
    - "https://mirror.gcr.io"
    - "https://daocloud.io"
    - "https://c.163.com/"
    - "https://huecker.io/"
    - "https://registry.docker-cn.com"
```
Пример плейбука

```yaml
- name: Install docker
  hosts: docker
  become: yes
  vars:
    docker_daemon_options:
      storage-driver: "overlay2"
      log-opts:
        max-size: "25m"
        max-file: "5"
        compress: "true"
      registry-mirrors:
        - "https://mirror.gcr.io"
        - "https://daocloud.io"
        - "https://c.163.com/"
        - "https://huecker.io/"
        - "https://registry.docker-cn.com"
  roles:
   - ./roles/docker
```
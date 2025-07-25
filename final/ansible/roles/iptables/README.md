### Ansible роль для конфиуграции iptables

Шаблон конфиуграции в `./templates/iptables.j2`

Если на хосте установлен Docker, то добавляется цепочка DOCKER-USER

Правила задаются в качестве переменных в `./vars/main.yml`

Пример:

```yaml
iptables_input_rules:
  - "-s 10.38.30.0/24 -p tcp -m tcp --dport 22 -j ACCEPT"
  - "-p tcp -m multiport --dports 80,443 -j ACCEPT"

iptables_docker_user_rules:
  - "-i {{interface_name}} -s 10.38.20.245 -p tcp --dport 80 -j ACCEPT"
  - "-i {{interface_name}} -p tcp --dport 5672 -j ACCEPT"
  ```

  iptables-restore.service - позволяет сохранять текущие правила в файле `/etc/sysconfig/iptables`, который загружается автоматически при каждой загрузке системы
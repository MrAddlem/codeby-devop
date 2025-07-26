

### Ansible Role: Docker

Эта роль устанавливает и настраивает RabbitMQ

### Variables

Доступные переменные со значениями по умолчанию (см. defaults/main.yml)

Пример плейбука

```yaml
# RabbitMQ
rabbitmq_redhat_version: 4.0.7

rabbitmq_extra_vhosts:
 - name: /app
   state: present

rabbitmq_users:
  - name: rabbitmqadmin
    password: rabbitmqadmin
    vhost: /
    configure_priv: ".*"
    read_priv: ".*"
    write_priv: ".*"
    # Define comma separated list of tags to assign to user:
    # management,policymaker,monitoring,administrator
    # required for management plugin.
    # https://www.rabbitmq.com/management.html
    tags: administrator
  - name: app
    password: app
    vhost: /app
    configure_priv: ".*"
    read_priv: ".*"
    write_priv: ".*"

# comma separated list of plugins to enable
rabbitmq_plugins: "rabbitmq_management"
```

### Ansible Role: Swap

Ansible роль для конфиграции swap в Linux

### Variables

Путь к swap файлу на сервере

```yml
swap_file_path: /swapfile
```

Размер swap файла

```yml
swap_file_size_mb: '512'
```

 Значение `vm.swappiness` в sysconfig

```yml
swap_swappiness: '60'
```

Если нужно удалить файл подкачки и отключить swap, установите это значение в `absent`

```yml
swap_file_state: present
```

Пример плейбука
```yml
- name: Install swap
  hosts: all
  become: yes
  vars:
    swap_file_size_mb: '1024'
    swap_swappiness: '60'
  roles:
    - ./roles/swap
```

# Packer Proxmox: Сборка шаблона Rocky Linux

Этот проект автоматизирует создание шаблона виртуальной машины Rocky Linux для Proxmox VE с использованием Packer.

## Возможности

- Автоматизированное создание шаблонов через Packer
- Поддержка загрузки через EFI (OVMF)
- Автоматическая установка через Kickstart
- Пост-установочная настройка с помощью Ansible
- Оптимизированные параметры ВМ для Proxmox
- Готовая Docker-среда со всеми зависимостями
- Корректная обработка сигналов завершения

## Требования

- Docker 20.10+ или Podman 3.0+
- Proxmox VE версии 6.4 или новее
- ISO-образ Rocky Linux Minimal

## Docker-образ

Проект включает Dockerfile для создания готового образа с установленным Packer и всеми зависимостями


## Скрипт entrypoint.sh

Скрипт обеспечивает корректную обработку сигналов и завершение работы Packer


### Особенности entrypoint.sh:
- Обработка сигнала SIGTERM для graceful shutdown
- Передача параметров через переменные окружения
- Автоматический переход в рабочую директорию
- Ожидание завершения процесса Packer

## Используемые плагины Packer

- [Плагин Proxmox](https://github.com/hashicorp/packer-plugin-proxmox) (v1.2.1)
- [Плагин Ansible](https://github.com/hashicorp/packer-plugin-ansible) (v1.1.3+)

## Файловая структура

```
.
├── Dockerfile               # Сборка Docker-образа
├── entrypoint.sh            # Скрипт запуска в контейнере
├── rocky9_efi.pkr.hcl       # Основной конфигурационный файл Packer
├── plugins.pkr.hcl          # Конфигурация плагинов Packer
├── http/
│   └── ks.cfg               # Kickstart файл для автоматической установки
└── scripts/
    ├── setup.yml            # Ansible-плейбук для настройки
    └── cleanup.sh           # Скрипт очистки системы
```

# Terraform Proxmox VM Management

Этот проект предоставляет инфраструктуру как код (IaC) для управления виртуальными машинами в Proxmox VE с использованием Terraform.

## Провайдер

Проект использует Terraform провайдер для Proxmox:
- GitHub: [bpg/terraform-provider-proxmox](https://github.com/bpg/terraform-provider-proxmox)
- Документация: [Provider Documentation](https://registry.terraform.io/providers/bpg/proxmox/latest/docs)

## Структура проекта

```
├── modules/
│   └── vm/
│       ├── README.md      # Документация модуля VM
│       ├── main.tf        # Основная конфигурация модуля
│       └── variables.tf   # Переменные модуля
├── provider.tf            # Конфигурация провайдера Proxmox
└── vms.tf                 # Определение виртуальных машин
```

## Требования

1. Terraform 1.0+
2. Proxmox VE 6.2+
3. Учетные данные для API Proxmox с необходимыми правами

## Настройка провайдера

Конфигурация провайдера находится в `provider.tf`:

```hcl
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.77.0"
    }
  }
  backend "http" {}
}

provider "proxmox" {
  endpoint           = var.proxmox_endpoint
  username           = var.proxmox_username
  password           = var.proxmox_password
  insecure           = true
  random_vm_ids      = true   # Включаем генерацию случайных ID
  random_vm_id_start = 800  # Начинать с 800
  random_vm_id_end   = 900  # Заканчивать на 900
}
```

### Особенности конфигурации

1. **HTTP Backend**: В конфигурации используется HTTP бэкенд (Gitlab Terraform states) для хранения состояния.

2. **Безопасность**: Параметр `insecure = true` отключает проверку SSL сертификата. Для production окружений рекомендуется использовать валидные сертификаты.

## Использование

### Создание виртуальных машин

Основные конфигурации ВМ находятся в файле `vms.tf`. Примеры:

1. ВМ со статическим IP:
```hcl
module "vm_static" {
  source         = "./modules/vm"
  name           = "vm-static"
  node           = "ex6"
  cpu_cores      = 2
  memory_mb      = 4096
  disk_size_gb   = 50
  disk_datastore = "SSD_storage"
  network_devices = [
    { bridge = "vmbr1", vlan_id = 10 }
  ]
  ipv4_address = "172.17.0.113/24"
  ipv4_gateway = "172.17.0.1"
  dns_servers  = ["172.17.0.5"]
}
```

2. ВМ с DHCP:
```hcl
module "vm_dhcp" {
  source         = "./modules/vm"
  name           = "vm-dhcp"
  node           = "ex6"
  cpu_cores      = 2
  memory_mb      = 4096
  disk_size_gb   = 50
  disk_datastore = "SSD_storage"
  network_devices = [
    { bridge = "vmbr2", vlan_id = 22 }
  ]
  ipv4_address = "DHCP"
}
```

### Команды Terraform

Инициализация:
```bash
terraform init
```

Планирование изменений:
```bash
terraform plan
```

Применение изменений:
```bash
terraform apply
```

Уничтожение инфраструктуры:
```bash
terraform destroy
```

## Параметры модуля VM

Основные параметры, которые можно передать в модуль VM:

| Параметр         | Тип     | Обязательный | Описание                          |
|------------------|---------|--------------|-----------------------------------|
| `name`           | string  | Да           | Имя виртуальной машины            |
| `node`           | string  | Да           | Имя ноды Proxmox                  |
| `cpu_cores`      | number  | Да           | Количество CPU ядер               |
| `memory_mb`      | number  | Да           | Объем памяти в MB                 |
| `disk_size_gb`   | number  | Да           | Размер диска в GB                 |
| `disk_datastore` | string  | Да           | Имя хранилища данных              |
| `network_devices`| list    | Да           | Список сетевых интерфейсов        |
| `ipv4_address`   | string  | Да           | IPv4 адрес или "DHCP"             |
| `ipv4_gateway`   | string  | Нет          | Шлюз по умолчанию                 |
| `dns_servers`    | list    | Нет          | Список DNS-серверов               |
| `protection`     | bool    | Нет          | Защита от удаления ВМ             |

## Примеры сетевых конфигураций

1. Один интерфейс:
```hcl
network_devices = [
  { bridge = "vmbr1", vlan_id = 10 }
]
```

2. Несколько интерфейсов:
```hcl
network_devices = [
  { bridge = "vmbr1", vlan_id = 10 },
  { bridge = "vmbr2", vlan_id = 20 }
]
```

3. С MAC-адресом:

```hcl
network_devices = [
  { bridge = "vmbr2", vlan_id = 20, mac_address = "00:50:56:ab:cd:ef" }
]
```
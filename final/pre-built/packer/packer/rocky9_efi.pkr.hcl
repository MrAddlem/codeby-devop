variable "proxmox_url" {
  type    = string
  default = "https://cluster2.ksb.local:8006/api2/json"
}

variable "proxmox_username" {
  type    = string
}

variable "proxmox_password" {
  type    = string
  sensitive = true
}

variable "ssh_username" {
  type    = string
}

variable "ssh_password" {
  type    = string
  sensitive = true
}

variable "ssh_host" {
  type    = string
  default = "127.0.0.1"
}

variable "ssh_port" {
  type    = string
  default = "2022"
}

variable "proxmox_node" {
  type    = string
  default = "ex25"
}

variable "proxmox_storage_pool" {
  type    = string
  default = "NFS_Images"
}

variable "rocky_image" {
  type    = string
  default = "Rocky-9-latest-x86_64-minimal.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:eedbdc2875c32c7f00e70fc861edef48587c7cbfd106885af80bdf434543820b"
}

variable "proxmox_iso_pool" {
  type    = string
  default = "NFS_Images:iso"
}

variable "proxmox_storage_format" {
  type    = string
  default = "raw"
}

variable "template_description" {
  type    = string
  default = "Rocky Linux 9 latest Minimal Template"
}

variable "template_name" {
  type    = string
  default = "rocky-9-latest-template"
}

source "proxmox-iso" "rocky9" {
  # Boot settings
  http_port_min = 9001
  http_port_max = 9001
  boot_command = [
  "<wait10>",                          # Пауза 10 сек
  "c setparams 'kickstart'<enter>",    # Переход в командную строку
  "linuxefi /images/pxeboot/vmlinuz ", # Ядро
    "inst.ks=http://10.38.30.120:{{ .HTTPPort }}/ks.cfg<enter>", # Kickstart
  "initrdefi /images/pxeboot/initrd.img<enter>", # Initramfs
  "boot<enter>"                        # Старт загрузки
]
  ballooning_minimum   = "0"
  http_directory       = "http"
  boot_wait            = "10s"
  # VM Hardware
  vm_name              = "${var.template_name}"
  vm_id                = "990"
  tags                 = "rocky;template"
  cpu_type             = "x86-64-v2-AES"
  memory               = "4096"
  cores                = "2"
  disable_kvm          = "false"
  sockets              = "1"
  bios                 = "ovmf"
  os                   = "l26"  # Тип гостевой ОС (Linux 5.x+)
  scsi_controller      = "virtio-scsi-pci"

  # EFI settings
  efi_config {
    efi_storage_pool  = "${var.proxmox_storage_pool}"
    efi_type          = "4m"
    pre_enrolled_keys = "true"
  }

  # ISO settings
  boot_iso {
    type = "scsi"
    iso_file = "${var.proxmox_iso_pool}/${var.rocky_image}"
    unmount = "true"
    iso_checksum = "${var.iso_checksum}"
  }

  # Disk settings
  disks {
    disk_size      = "10G"
    format         = "${var.proxmox_storage_format}"
    storage_pool   = "${var.proxmox_storage_pool}"
    type           = "scsi"
    cache_mode     = "writeback"
  }

  # Network
  network_adapters {
    model       = "virtio"
    bridge      = "vmbr2"
    mac_address = "12:B0:1B:0F:8A:0F"
    vlan_tag    = "22"
    firewall    = "false"
  }

  # Proxmox connection
  proxmox_url          = "${var.proxmox_url}"
  insecure_skip_tls_verify = true
  username             = "${var.proxmox_username}"
  password             = "${var.proxmox_password}"
  node                 = "${var.proxmox_node}"

  # SSH
  ssh_username       = "${var.ssh_username}"
  ssh_password       = "${var.ssh_password}"
  ssh_host           = "${var.ssh_host}"
  ssh_port           = "${var.ssh_port}"
  ssh_timeout        = "180m"

  # Other
  template_description = "Managed by Terraform, generated on ${timestamp()}"
  qemu_agent           = "true"
  machine              = "q35"
}

build {
  sources = ["source.proxmox-iso.rocky9"]

  provisioner "shell" {
    execute_command = "sudo -S -E bash '{{ .Path }}'"
    inline = [
      "dnf -y update",
      "dnf -y install python3",
      "dnf -y install python3-pip",
      "pip3 install ansible"
    ]
  }

  provisioner "ansible-local" {
    playbook_file = "scripts/setup.yml"
  }

  provisioner "shell" {
    execute_command = "sudo -S -E bash '{{ .Path }}'"
    scripts = ["scripts/cleanup.sh"]
  }
}

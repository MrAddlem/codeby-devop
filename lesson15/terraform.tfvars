proxmox_api_url = "https://10.38.16.18:8006/api2/json"
proxmox_username = "root@pam"
proxmox_password = "Hj,byUelNdfhm24!"
proxmox_insecure = false  # Используйте false для production

# Параметры LXC контейнера
mplate_id = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
hostname = "Example1"

lxc_node_name = "ex10"
lxc_vm_id = 585
lxc_one = "production"
lxc_ip_address = "10.38.16.115"
lxc_gateway = "10.38.16.1"

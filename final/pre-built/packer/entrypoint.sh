#!/bin/bash
set -e

cleanup() {
  echo "Received SIGTERM, stopping packer gracefully..."
  kill -s TERM "$PACKER_PID"
  wait "$PACKER_PID"
}

trap cleanup SIGTERM

cd /builds/devops/pre-built/packer/packer

# Передача аргументов в packer из переменных окружения
packer build -force \
  -var "proxmox_url=$PACKER_PROXMOX_URL" \
  -var "proxmox_username=$PACKER_PROXMOX_USERNAME" \
  -var "proxmox_password=$PACKER_PROXMOX_PASSWORD" \
  -var "ssh_username=$PACKER_SSH_USERNAME" \
  -var "ssh_password=$PACKER_SSH_PASSWORD" \
  rocky9_efi.pkr.hcl &

PACKER_PID=$!
wait "$PACKER_PID"

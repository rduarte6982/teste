#!/bin/bash

# Configurações da VM
VM_ID=150                # ID da VM
VM_NAME="UmbrelOS"       # Nome da VM
VM_DISK_SIZE="64G"       # Tamanho do disco
VM_RAM="4096"           # Memória RAM (4GB)
VM_CORES="2"            # Número de vCPUs
ISO_URL="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso"
ISO_PATH="/var/lib/vz/template/iso/debian-12-netinst.iso"

# Atualiza e instala pacotes necessários
echo "🔄 Atualizando pacotes..."
apt update && apt install -y curl wget qemu-guest-agent cloud-init

# Baixa a ISO do Debian se não existir
if [ ! -f "$ISO_PATH" ]; then
    echo "📥 Baixando a ISO do Debian..."
    wget -O "$ISO_PATH" "$ISO_URL"
fi

# Cria a VM no Proxmox
echo "⚙️ Criando a VM no Proxmox..."
qm create $VM_ID --name $VM_NAME --memory $VM_RAM --cores $VM_CORES --net0 virtio,bridge=vmbr0 --ostype l26
qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 local-lvm:$VM_DISK_SIZE
qm set $VM_ID --boot order=scsi0
qm set $VM_ID --ide2 local:iso/debian-12-netinst.iso,media=cdrom
qm set $VM_ID --agent enabled=1
qm set $VM_ID --serial0 socket --vga serial0

# Inicia a VM para instalar o Debian
echo "🚀 Iniciando a VM para instalação..."
qm start $VM_ID

# Aguarda a instalação do Debian e configuração via SSH
echo "⌛ Aguarde a instalação do Debian e configure um usuário root. Depois, rode este script novamente para instalar o Umbrel."

echo "✅ Passo 1 finalizado! Agora acesse a VM via Proxmox e instale o Debian manualmente."
exit 0

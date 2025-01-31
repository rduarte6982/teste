<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
  <title></title>
  <meta name="Generator" content="Cocoa HTML Writer">
  <meta name="CocoaVersion" content="2575.4">
  <style type="text/css">
    p.p1 {margin: 0.0px 0.0px 0.0px 0.0px; font: 12.0px Helvetica}
    p.p2 {margin: 0.0px 0.0px 0.0px 0.0px; font: 12.0px Helvetica; min-height: 14.0px}
  </style>
</head>
<body>
<p class="p1">#!/bin/bash</p>
<p class="p2"><br></p>
<p class="p1"># Configurações da VM</p>
<p class="p1">VM_ID=150<span class="Apple-converted-space">                </span># ID da VM</p>
<p class="p1">VM_NAME="UmbrelOS" <span class="Apple-converted-space">      </span># Nome da VM</p>
<p class="p1">VM_DISK_SIZE="64G" <span class="Apple-converted-space">      </span># Tamanho do disco</p>
<p class="p1">VM_RAM="4096" <span class="Apple-converted-space">          </span># Memória RAM (4GB)</p>
<p class="p1">VM_CORES="2"<span class="Apple-converted-space">            </span># Número de vCPUs</p>
<p class="p1">ISO_URL="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso"</p>
<p class="p1">ISO_PATH="/var/lib/vz/template/iso/debian-12-netinst.iso"</p>
<p class="p2"><br></p>
<p class="p1"># Atualiza e instala pacotes necessários</p>
<p class="p1">echo "🔄 Atualizando pacotes..."</p>
<p class="p1">apt update &amp;&amp; apt install -y curl wget qemu-guest-agent cloud-init</p>
<p class="p2"><br></p>
<p class="p1"># Baixa a ISO do Debian se não existir</p>
<p class="p1">if [ ! -f "$ISO_PATH" ]; then</p>
<p class="p1"><span class="Apple-converted-space">    </span>echo "📥 Baixando a ISO do Debian..."</p>
<p class="p1"><span class="Apple-converted-space">    </span>wget -O "$ISO_PATH" "$ISO_URL"</p>
<p class="p1">fi</p>
<p class="p2"><br></p>
<p class="p1"># Cria a VM no Proxmox</p>
<p class="p1">echo "⚙️ Criando a VM no Proxmox..."</p>
<p class="p1">qm create $VM_ID --name $VM_NAME --memory $VM_RAM --cores $VM_CORES --net0 virtio,bridge=vmbr0 --ostype l26</p>
<p class="p1">qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 local-lvm:$VM_DISK_SIZE</p>
<p class="p1">qm set $VM_ID --boot order=scsi0</p>
<p class="p1">qm set $VM_ID --ide2 local:iso/debian-12-netinst.iso,media=cdrom</p>
<p class="p1">qm set $VM_ID --agent enabled=1</p>
<p class="p1">qm set $VM_ID --serial0 socket --vga serial0</p>
<p class="p2"><br></p>
<p class="p1"># Inicia a VM para instalar o Debian</p>
<p class="p1">echo "🚀 Iniciando a VM para instalação..."</p>
<p class="p1">qm start $VM_ID</p>
<p class="p2"><br></p>
<p class="p1"># Aguarda a instalação do Debian e configuração via SSH</p>
<p class="p1">echo "⌛ Aguarde a instalação do Debian e configure um usuário root. Depois, rode este script novamente para instalar o Umbrel."</p>
<p class="p2"><br></p>
<p class="p1">echo "✅ Passo 1 finalizado! Agora acesse a VM via Proxmox e instale o Debian manualmente."</p>
<p class="p1">exit 0</p>
</body>
</html>

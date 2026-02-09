#!/bin/bash
# ============================================
# DEPLOY AZURE VM - Para Azure Cloud Shell
# ============================================

# Variables - MODIFICAR SEGUN TUS NECESIDADES
RESOURCE_GROUP="rg-nataliaquintero"
VM_NAME="vm-nataliaquintero"
LOCATION="canadacentral"
VM_SIZE="Standard_B1s"


echo "============================================"
echo "   DEPLOY AZURE VM - Natalia Quintero"
echo "============================================"

# ============================================
# PASO 1: Crear grupo de recursos
# ============================================
echo ""
echo "[1/5] Creando grupo de recursos..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# ============================================
# PASO 2: Crear la VM
# ============================================
echo ""
echo "[2/5] Creando maquina virtual (esto tarda unos minutos)..."
az vm create \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME \
    --image Ubuntu2204 \
    --size $VM_SIZE \
    --admin-username $ADMIN_USER \
    --admin-password $ADMIN_PASSWORD \
    --public-ip-sku Standard \
    --authentication-type password

# ============================================
# PASO 3: Abrir puertos HTTP/HTTPS
# ============================================
echo ""
echo "[3/5] Abriendo puertos 80 y 443..."
az vm open-port --resource-group $RESOURCE_GROUP --name $VM_NAME --port 80 --priority 1001
az vm open-port --resource-group $RESOURCE_GROUP --name $VM_NAME --port 443 --priority 1002

# ============================================
# PASO 4: Obtener IP publica
# ============================================
echo ""
echo "[4/5] Obteniendo IP publica..."
IP=$(az vm show --resource-group $RESOURCE_GROUP --name $VM_NAME --show-details --query publicIps -o tsv)
echo "IP Publica: $IP"

# ============================================
# PASO 5: Instalar y configurar Nginx
# ============================================
echo ""
echo "[5/5] Instalando Nginx y configurando servidor..."

az vm run-command invoke \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME \
    --command-id RunShellScript \
    --scripts '
#!/bin/bash
apt update
apt install -y nginx

# Configurar Nginx
cat > /etc/nginx/sites-available/default << "EOF"
server {
    listen 80;
    listen [::]:80;
    server_name _;
    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /en/ {
        try_files $uri $uri/ /en/index.html;
    }

    location /fr/ {
        try_files $uri $uri/ /fr/index.html;
    }

    location /assets/ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml;
}
EOF

# Preparar directorios
rm -rf /var/www/html/*
mkdir -p /var/www/html/en
mkdir -p /var/www/html/fr
mkdir -p /var/www/html/assets
chown -R www-data:www-data /var/www/html/

# Reiniciar Nginx
systemctl enable nginx
systemctl restart nginx
'

echo ""
echo "============================================"
echo "     VM CREADA EXITOSAMENTE!"
echo "============================================"
echo ""
echo "IP Publica: $IP"
echo "Usuario: $ADMIN_USER"
echo "Password: $ADMIN_PASSWORD"
echo ""
echo "Conectate via SSH:"
echo "  ssh $ADMIN_USER@$IP"
echo ""
echo "Prueba Nginx:"
echo "  http://$IP"
echo ""
echo "============================================"

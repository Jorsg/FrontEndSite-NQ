# ============================================
# SCRIPT COMPLETO DE DEPLOY - TODO EN UNO
# ============================================
# Este script crea la VM Y sube el sitio web

param(
    [string]$AdminPassword = "NataliaQ2025!"
)

# Variables
$RESOURCE_GROUP = "rg-nataliaquintero"
$VM_NAME = "vm-nataliaquintero"
$LOCATION = "canadacentral"
$VM_SIZE = "Standard_B1s"
$ADMIN_USER = "azureuser"
$LOCAL_PATH = "d:\Repos\Web-Natalia_Quintero\website"

Write-Host @"
============================================
   DEPLOY AZURE VM - Natalia Quintero
============================================
"@ -ForegroundColor Cyan

# ============================================
# PASO 1: Login
# ============================================
Write-Host "`n[1/7] Iniciando sesion en Azure..." -ForegroundColor Yellow
az login --only-show-errors

# ============================================
# PASO 2: Crear grupo de recursos
# ============================================
Write-Host "`n[2/7] Creando grupo de recursos..." -ForegroundColor Yellow
az group create --name $RESOURCE_GROUP --location $LOCATION --only-show-errors

# ============================================
# PASO 3: Crear VM
# ============================================
Write-Host "`n[3/7] Creando maquina virtual (esto puede tardar unos minutos)..." -ForegroundColor Yellow
az vm create `
    --resource-group $RESOURCE_GROUP `
    --name $VM_NAME `
    --image Ubuntu2204 `
    --size $VM_SIZE `
    --admin-username $ADMIN_USER `
    --admin-password $AdminPassword `
    --public-ip-sku Standard `
    --authentication-type password `
    --only-show-errors

# ============================================
# PASO 4: Abrir puertos
# ============================================
Write-Host "`n[4/7] Abriendo puertos HTTP/HTTPS..." -ForegroundColor Yellow
az vm open-port --resource-group $RESOURCE_GROUP --name $VM_NAME --port 80 --priority 1001 --only-show-errors
az vm open-port --resource-group $RESOURCE_GROUP --name $VM_NAME --port 443 --priority 1002 --only-show-errors

# Obtener IP
$IP = az vm show --resource-group $RESOURCE_GROUP --name $VM_NAME --show-details --query publicIps -o tsv
Write-Host "IP Publica: $IP" -ForegroundColor Green

# ============================================
# PASO 5: Instalar Nginx
# ============================================
Write-Host "`n[5/7] Instalando y configurando Nginx..." -ForegroundColor Yellow

$NGINX_SETUP = @'
#!/bin/bash
apt update
apt install -y nginx

# Configurar Nginx
cat > /etc/nginx/sites-available/default << 'EOF'
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

systemctl enable nginx
systemctl restart nginx
rm -rf /var/www/html/*
mkdir -p /var/www/html/en /var/www/html/fr /var/www/html/assets
'@

az vm run-command invoke `
    --resource-group $RESOURCE_GROUP `
    --name $VM_NAME `
    --command-id RunShellScript `
    --scripts $NGINX_SETUP `
    --only-show-errors

# ============================================
# PASO 6: Leer y subir archivos del sitio
# ============================================
Write-Host "`n[6/7] Subiendo archivos del sitio web..." -ForegroundColor Yellow

# Leer index.html y subirlo
$indexContent = Get-Content "$LOCAL_PATH\index.html" -Raw -Encoding UTF8
$indexBase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($indexContent))

$stylesContent = Get-Content "$LOCAL_PATH\styles.css" -Raw -Encoding UTF8
$stylesBase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($stylesContent))

$indexEnContent = Get-Content "$LOCAL_PATH\en\index.html" -Raw -Encoding UTF8
$indexEnBase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($indexEnContent))

$indexFrContent = Get-Content "$LOCAL_PATH\fr\index.html" -Raw -Encoding UTF8
$indexFrBase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($indexFrContent))

# Script para decodificar y guardar archivos
$UPLOAD_SCRIPT = @"
#!/bin/bash
echo '$indexBase64' | base64 -d > /var/www/html/index.html
echo '$stylesBase64' | base64 -d > /var/www/html/styles.css
echo '$indexEnBase64' | base64 -d > /var/www/html/en/index.html
echo '$indexFrBase64' | base64 -d > /var/www/html/fr/index.html
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/
"@

az vm run-command invoke `
    --resource-group $RESOURCE_GROUP `
    --name $VM_NAME `
    --command-id RunShellScript `
    --scripts $UPLOAD_SCRIPT `
    --only-show-errors

# ============================================
# PASO 7: Verificar
# ============================================
Write-Host "`n[7/7] Verificando instalacion..." -ForegroundColor Yellow

$VERIFY_SCRIPT = 'nginx -t && systemctl status nginx --no-pager && ls -la /var/www/html/'

az vm run-command invoke `
    --resource-group $RESOURCE_GROUP `
    --name $VM_NAME `
    --command-id RunShellScript `
    --scripts $VERIFY_SCRIPT `
    --only-show-errors

Write-Host @"

============================================
     DEPLOY COMPLETADO EXITOSAMENTE!
============================================
"@ -ForegroundColor Green

Write-Host "Tu sitio web esta disponible en:" -ForegroundColor White
Write-Host ""
Write-Host "  Espanol:  http://$IP" -ForegroundColor Cyan
Write-Host "  English:  http://$IP/en/" -ForegroundColor Cyan
Write-Host "  Francais: http://$IP/fr/" -ForegroundColor Cyan
Write-Host ""
Write-Host "Credenciales SSH:" -ForegroundColor White
Write-Host "  Usuario:  $ADMIN_USER" -ForegroundColor Yellow
Write-Host "  Password: $AdminPassword" -ForegroundColor Yellow
Write-Host "  Comando:  ssh ${ADMIN_USER}@${IP}" -ForegroundColor Yellow
Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "NOTA: Los assets (imagenes) deben subirse manualmente." -ForegroundColor Magenta
Write-Host "Ejecuta este comando para subir la carpeta assets:" -ForegroundColor White
Write-Host ""
Write-Host "scp -r `"$LOCAL_PATH\assets`" ${ADMIN_USER}@${IP}:/tmp/ && ssh ${ADMIN_USER}@${IP} `"sudo cp -r /tmp/assets/* /var/www/html/assets/ && sudo chown -R www-data:www-data /var/www/html/`"" -ForegroundColor Green
Write-Host ""

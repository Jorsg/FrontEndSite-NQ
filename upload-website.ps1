# ============================================
# SCRIPT PARA SUBIR SITIO WEB A LA VM
# ============================================
# Ejecutar DESPUES de deploy-azure.ps1

# Variables - DEBE COINCIDIR con deploy-azure.ps1
$RESOURCE_GROUP = "rg-nataliaquintero"
$VM_NAME = "vm-nataliaquintero"
$ADMIN_USER = "azureuser"

# Obtener IP de la VM
$IP = az vm show --resource-group $RESOURCE_GROUP --name $VM_NAME --show-details --query publicIps -o tsv
Write-Host "IP de la VM: $IP" -ForegroundColor Cyan

# Ruta local del sitio web
$LOCAL_PATH = "d:\Repos\Web-Natalia_Quintero\website"

Write-Host "=== Subiendo archivos del sitio web ===" -ForegroundColor Cyan

# Crear script de configuracion para ejecutar en la VM
$SETUP_SCRIPT = @"
#!/bin/bash
# Limpiar directorio web
sudo rm -rf /var/www/html/*

# Crear estructura de directorios
sudo mkdir -p /var/www/html/en
sudo mkdir -p /var/www/html/fr
sudo mkdir -p /var/www/html/assets

# Configurar permisos
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# Configurar Nginx
sudo tee /etc/nginx/sites-available/default > /dev/null << 'NGINXCONFIG'
server {
    listen 80;
    listen [::]:80;

    server_name _;
    root /var/www/html;
    index index.html;

    # Espanol (raiz)
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Ingles
    location /en/ {
        try_files \$uri \$uri/ /en/index.html;
    }

    # Frances
    location /fr/ {
        try_files \$uri \$uri/ /fr/index.html;
    }

    # Assets con cache
    location /assets/ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # Gzip
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml;
}
NGINXCONFIG

# Reiniciar Nginx
sudo nginx -t && sudo systemctl restart nginx
echo "Nginx configurado correctamente"
"@

# Guardar script temporal
$SETUP_SCRIPT | Out-File -FilePath "$env:TEMP\setup-nginx.sh" -Encoding utf8

Write-Host "=== Configurando Nginx en la VM ===" -ForegroundColor Cyan
az vm run-command invoke `
    --resource-group $RESOURCE_GROUP `
    --name $VM_NAME `
    --command-id RunShellScript `
    --scripts $SETUP_SCRIPT

Write-Host ""
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "IMPORTANTE: Ahora debes subir los archivos" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Ejecuta estos comandos en una nueva terminal:" -ForegroundColor Cyan
Write-Host ""
Write-Host "# 1. Conectarte a la VM:" -ForegroundColor White
Write-Host "ssh ${ADMIN_USER}@${IP}" -ForegroundColor Green
Write-Host ""
Write-Host "# 2. Una vez conectado, desde OTRA terminal local, ejecuta:" -ForegroundColor White
Write-Host "scp -r `"$LOCAL_PATH\index.html`" ${ADMIN_USER}@${IP}:/tmp/" -ForegroundColor Green
Write-Host "scp -r `"$LOCAL_PATH\styles.css`" ${ADMIN_USER}@${IP}:/tmp/" -ForegroundColor Green
Write-Host "scp -r `"$LOCAL_PATH\en`" ${ADMIN_USER}@${IP}:/tmp/" -ForegroundColor Green
Write-Host "scp -r `"$LOCAL_PATH\fr`" ${ADMIN_USER}@${IP}:/tmp/" -ForegroundColor Green
Write-Host "scp -r `"$LOCAL_PATH\assets`" ${ADMIN_USER}@${IP}:/tmp/" -ForegroundColor Green
Write-Host ""
Write-Host "# 3. Luego en la VM (via SSH):" -ForegroundColor White
Write-Host "sudo cp /tmp/index.html /var/www/html/" -ForegroundColor Green
Write-Host "sudo cp /tmp/styles.css /var/www/html/" -ForegroundColor Green
Write-Host "sudo cp -r /tmp/en /var/www/html/" -ForegroundColor Green
Write-Host "sudo cp -r /tmp/fr /var/www/html/" -ForegroundColor Green
Write-Host "sudo cp -r /tmp/assets /var/www/html/" -ForegroundColor Green
Write-Host "sudo chown -R www-data:www-data /var/www/html/" -ForegroundColor Green
Write-Host ""
Write-Host "# 4. Verificar:" -ForegroundColor White
Write-Host "Visita: http://$IP" -ForegroundColor Green
Write-Host ""

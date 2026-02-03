# ============================================
# SCRIPT DE DEPLOY AZURE VM - Natalia Quintero
# ============================================
# Ejecutar en PowerShell

# Variables - MODIFICAR SEGUN TUS NECESIDADES
$RESOURCE_GROUP = "rg-nataliaquintero"
$VM_NAME = "vm-nataliaquintero"
$LOCATION = "canadacentral"
$VM_SIZE = "Standard_B1s"
$ADMIN_USER = "azureuser"
$ADMIN_PASSWORD = "NataliaQ2025!"  # Cambiar por una contrasena segura

# ============================================
# PASO 1: Login en Azure
# ============================================
Write-Host "=== Iniciando sesion en Azure ===" -ForegroundColor Cyan
az login

# ============================================
# PASO 2: Crear grupo de recursos
# ============================================
Write-Host "=== Creando grupo de recursos ===" -ForegroundColor Cyan
az group create --name $RESOURCE_GROUP --location $LOCATION

# ============================================
# PASO 3: Crear la VM con Ubuntu
# ============================================
Write-Host "=== Creando maquina virtual ===" -ForegroundColor Cyan
az vm create `
    --resource-group $RESOURCE_GROUP `
    --name $VM_NAME `
    --image Ubuntu2204 `
    --size $VM_SIZE `
    --admin-username $ADMIN_USER `
    --admin-password $ADMIN_PASSWORD `
    --public-ip-sku Standard `
    --authentication-type password

# ============================================
# PASO 4: Abrir puertos HTTP, HTTPS y SSH
# ============================================
Write-Host "=== Abriendo puertos 80, 443 y 22 ===" -ForegroundColor Cyan
az vm open-port --resource-group $RESOURCE_GROUP --name $VM_NAME --port 80 --priority 1001
az vm open-port --resource-group $RESOURCE_GROUP --name $VM_NAME --port 443 --priority 1002
az vm open-port --resource-group $RESOURCE_GROUP --name $VM_NAME --port 22 --priority 1003

# ============================================
# PASO 5: Obtener IP publica
# ============================================
Write-Host "=== Obteniendo IP publica ===" -ForegroundColor Cyan
$IP = az vm show --resource-group $RESOURCE_GROUP --name $VM_NAME --show-details --query publicIps -o tsv
Write-Host "IP Publica de tu VM: $IP" -ForegroundColor Green

# ============================================
# PASO 6: Instalar Nginx y configurar servidor
# ============================================
Write-Host "=== Instalando Nginx en la VM ===" -ForegroundColor Cyan
az vm run-command invoke `
    --resource-group $RESOURCE_GROUP `
    --name $VM_NAME `
    --command-id RunShellScript `
    --scripts "sudo apt update && sudo apt install -y nginx && sudo systemctl enable nginx && sudo systemctl start nginx"

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "VM CREADA EXITOSAMENTE!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host "IP Publica: $IP" -ForegroundColor Yellow
Write-Host "Usuario: $ADMIN_USER" -ForegroundColor Yellow
Write-Host "Password: $ADMIN_PASSWORD" -ForegroundColor Yellow
Write-Host ""
Write-Host "Para conectarte via SSH:" -ForegroundColor Cyan
Write-Host "ssh ${ADMIN_USER}@${IP}" -ForegroundColor White
Write-Host ""
Write-Host "Prueba Nginx visitando: http://$IP" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Green

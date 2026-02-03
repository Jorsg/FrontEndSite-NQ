#!/bin/bash
# ============================================
# SUBIR SITIO WEB A LA VM
# Ejecutar DESPUES de deploy-azure-cloudshell.sh
# ============================================

# Variables
RESOURCE_GROUP="rg-nataliaquintero"
VM_NAME="vm-nataliaquintero"

# Obtener IP
IP=$(az vm show --resource-group $RESOURCE_GROUP --name $VM_NAME --show-details --query publicIps -o tsv)
echo "IP de la VM: $IP"

echo ""
echo "============================================"
echo "   INSTRUCCIONES PARA SUBIR ARCHIVOS"
echo "============================================"
echo ""
echo "OPCION 1: Subir archivos desde tu PC local"
echo "-------------------------------------------"
echo "Desde tu terminal LOCAL (no Cloud Shell), ejecuta:"
echo ""
echo "scp index.html styles.css azureuser@$IP:/tmp/"
echo "scp -r en fr assets azureuser@$IP:/tmp/"
echo ""
echo "Luego conectate a la VM y mueve los archivos:"
echo "ssh azureuser@$IP"
echo "sudo cp /tmp/index.html /tmp/styles.css /var/www/html/"
echo "sudo cp -r /tmp/en /tmp/fr /tmp/assets /var/www/html/"
echo "sudo chown -R www-data:www-data /var/www/html/"
echo ""
echo ""
echo "OPCION 2: Clonar desde GitHub (si tienes repo)"
echo "-----------------------------------------------"
echo "ssh azureuser@$IP"
echo "cd /tmp && git clone <TU-REPO-URL> website"
echo "sudo cp -r /tmp/website/* /var/www/html/"
echo "sudo chown -R www-data:www-data /var/www/html/"
echo ""
echo ""
echo "OPCION 3: Subir via Cloud Shell (archivos pequenos)"
echo "----------------------------------------------------"
echo "1. En Cloud Shell, haz clic en el icono de 'Upload'"
echo "2. Sube tus archivos"
echo "3. Luego usa SCP desde Cloud Shell hacia la VM"
echo ""
echo "============================================"
echo "Verifica tu sitio en: http://$IP"
echo "============================================"

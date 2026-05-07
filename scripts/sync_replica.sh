#!/bin/bash
# Script para rodar no Raspberry Pi 2 (Secundário)

# Variáveis
IP_PI_1="192.168.1.50" # Substitua pelo IP do seu Pi 1
USER_PI_1="pi"
SOURCE_DIR="/opt/gitea_server/gitea_data/"
DEST_DIR="/opt/gitea_data_replica/"

echo "[$(date)] Iniciando sincronização via rsync..."

# Sincroniza apagando os arquivos deletados do Pi 1
rsync -avz --delete ${USER_PI_1}@${IP_PI_1}:${SOURCE_DIR} ${DEST_DIR}

echo "[$(date)] Sincronização concluída!"

#!/bin/bash
# Script para rodar no Raspberry Pi 1 (Primário)

# Variáveis
BACKUP_DIR="/opt/gitea_server/gitea_data/backups"
CONTAINER_NAME="gitea"
GDRIVE_REMOTE="gdrive:Gitea_Backups/"

echo "[$(date)] Iniciando processo de backup do Gitea..."

# Garante que a pasta de backup exista
mkdir -p ${BACKUP_DIR}

# 1. Entra na pasta onde o Gitea vai salvar o dump
cd ${BACKUP_DIR} || exit 1

# 2. Roda o comando de dump de dentro do container Docker
echo "[$(date)] Gerando dump do banco de dados e repositórios..."
# O comando de dump requer um terminal interativo? Melhor usar sem -it no cron:
docker exec -u git ${CONTAINER_NAME} bash -c "gitea dump -c /data/gitea/conf/app.ini --file /data/backups/gitea-dump-\$(date +%Y%m%d%H%M%S).zip"

# 3. Pega o arquivo .zip gerado e envia para o Google Drive
echo "[$(date)] Enviando backup para o Google Drive via rclone..."
rclone copy ${BACKUP_DIR}/*.zip ${GDRIVE_REMOTE}

# 4. Apaga backups locais mais antigos que 7 dias para não lotar o SD Card
echo "[$(date)] Limpando backups antigos (mais de 7 dias)..."
find ${BACKUP_DIR}/*.zip -mtime +7 -exec rm {} \;

echo "[$(date)] Backup concluído com sucesso!"

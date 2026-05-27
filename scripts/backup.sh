#!/bin/bash
# ============================================================
#  backup.sh — Script de respaldo automatizado
#  Ministerio del Trabajo | Infraestructura TI
# ============================================================

FECHA=$(date +"%Y%m%d_%H%M%S")
DIR_BACKUP="/srv/backups/mintrabajo"
DIR_PROYECTO="/contenedor1/proyecto-mintrabajo"
LOG_FILE="/var/log/mintrabajo/backup.log"
MYSQL_USER="mintrabajo"
MYSQL_PASS="mintrabajo123"
MYSQL_DB="mintrabajo_db"

mkdir -p "$DIR_BACKUP"
mkdir -p "$(dirname $LOG_FILE)"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "================================================"
log "  INICIO DE RESPALDO — Ministerio del Trabajo"
log "================================================"

# 1. Respaldo de archivos del proyecto
log "[1/3] Respaldando archivos del proyecto..."
tar -czf "$DIR_BACKUP/proyecto_${FECHA}.tar.gz" "$DIR_PROYECTO" 2>>"$LOG_FILE"
if [ $? -eq 0 ]; then
    log "       Archivos respaldados: proyecto_${FECHA}.tar.gz"
else
    log "       Error al respaldar archivos del proyecto"
fi

# 2. Respaldo de base de datos MySQL
log "[2/3] Respaldando base de datos MySQL..."
docker exec mysql-db mysqldump -u"$MYSQL_USER" -p"$MYSQL_PASS" "$MYSQL_DB" \
    > "$DIR_BACKUP/db_${FECHA}.sql" 2>>"$LOG_FILE"
if [ $? -eq 0 ]; then
    log "       Base de datos respaldada: db_${FECHA}.sql"
else
    log "       Error al respaldar la base de datos"
fi

# 3. Respaldo de archivos compartidos Samba
log "[3/3] Respaldando archivos compartidos..."
tar -czf "$DIR_BACKUP/samba_${FECHA}.tar.gz" /contenedor1/proyecto-mintrabajo/files/ 2>>"$LOG_FILE"
if [ $? -eq 0 ]; then
    log "       Samba respaldado: samba_${FECHA}.tar.gz"
else
    log "       Error al respaldar archivos Samba"
fi

# Eliminar respaldos con más de 7 días
log "Limpiando respaldos antiguos (> 7 días)..."
find "$DIR_BACKUP" -type f -mtime +7 -delete
log "Limpieza completada."

log "================================================"
log "  RESPALDO FINALIZADO — $FECHA"
log "  Ubicación: $DIR_BACKUP"
log "================================================"

exit 0

#!/bin/bash
# ============================================================
#  despliegue.sh — Despliegue automático de servicios Docker
#  Ministerio del Trabajo | Infraestructura TI
# ============================================================

DIR_PROYECTO="/contenedor1/proyecto-mintrabajo/docker"
LOG_FILE="/var/log/mintrabajo/despliegue.log"
VERDE='\033[0;32m'; ROJO='\033[0;31m'; AMARILLO='\033[1;33m'; NC='\033[0m'

mkdir -p "$(dirname $LOG_FILE)"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"; }

log "═══════════════════════════════════════════════"
log "  INICIO DESPLIEGUE — Ministerio del Trabajo"
log "═══════════════════════════════════════════════"

# Verificar que Docker esté corriendo
if ! systemctl is-active --quiet docker; then
    log " Docker no está activo. Iniciando..."
    sudo systemctl start docker
    sleep 3
fi

cd "$DIR_PROYECTO" || { log " No se encontró el directorio del proyecto: $DIR_PROYECTO"; exit 1; }

# Paso 1: Bajar contenedores existentes
log "[1/4] Bajando contenedores existentes..."
sudo docker-compose down 2>>"$LOG_FILE"
log "       Contenedores detenidos"

# Paso 2: Reconstruir imágenes
log "[2/4] Reconstruyendo imágenes Docker..."
sudo docker-compose build --no-cache 2>>"$LOG_FILE"
if [ $? -eq 0 ]; then
    log "       Imágenes construidas correctamente"
else
    log "       Error al construir imágenes"
    exit 1
fi

# Paso 3: Levantar servicios
log "[3/4] Levantando todos los servicios..."
sudo docker-compose up -d 2>>"$LOG_FILE"
if [ $? -eq 0 ]; then
    log "       Servicios levantados"
else
    log "       Error al levantar servicios"
    exit 1
fi

# Paso 4: Verificar estado
log "[4/4] Verificando estado de contenedores..."
sleep 10
CONTENEDORES=("web-apache" "mysql-db" "ntp-chrony" "file-server")
ERRORES=0
for ct in "${CONTENEDORES[@]}"; do
    STATUS=$(docker inspect -f '{{.State.Status}}' "$ct" 2>/dev/null)
    if [ "$STATUS" = "running" ]; then
        log "       $ct: running"
    else
        log "       $ct: ${STATUS:-no encontrado}"
        ERRORES=$((ERRORES+1))
    fi
done

log "═══════════════════════════════════════════════"
if [ $ERRORES -eq 0 ]; then
    log "  DESPLIEGUE EXITOSO  — Todos los servicios activos"
else
    log "  DESPLIEGUE COMPLETADO CON $ERRORES ERROR(ES) ⚠"
fi
log "═══════════════════════════════════════════════"

exit 0

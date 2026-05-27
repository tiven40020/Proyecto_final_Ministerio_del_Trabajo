#!/bin/bash
# ============================================================
#  monitoreo.sh — Monitoreo básico de infraestructura
#  Ministerio del Trabajo | Infraestructura TI
# ============================================================

LOG_FILE="/var/log/mintrabajo/monitoreo.log"
mkdir -p "$(dirname $LOG_FILE)"

ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[0;34m'
NC='\033[0m'

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

encabezado() {
    echo -e "${AZUL}"
    echo "╔══════════════════════════════════════════════════╗"
    echo "║     MONITOREO — Ministerio del Trabajo           ║"
    echo "║     $(date '+%Y-%m-%d %H:%M:%S')                    ║"
    echo "╚══════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

seccion() { echo -e "\n${AMARILLO}▶ $1${NC}"; echo "─────────────────────────────────────"; }

# ── CPU ─────────────────────────────────────────────────────
check_cpu() {
    seccion "USO DE CPU"
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    echo -e "  CPU en uso: ${VERDE}${CPU}%${NC}"
    log "CPU: ${CPU}%"
    if (( $(echo "$CPU > 90" | bc -l) )); then
        echo -e "  ${ROJO}⚠ ADVERTENCIA: CPU supera el 90%${NC}"
        log "ALERTA: CPU crítica ${CPU}%"
    fi
}

# ── MEMORIA ─────────────────────────────────────────────────
check_memoria() {
    seccion "USO DE MEMORIA RAM"
    free -h | grep -E "Mem|Swap" | awk '{printf "  %-6s Total:%-8s Usado:%-8s Libre:%s\n", $1, $2, $3, $4}'
    USO_MEM=$(free | grep Mem | awk '{printf "%.0f", $3/$2*100}')
    log "Memoria usada: ${USO_MEM}%"
    if [ "$USO_MEM" -gt 85 ]; then
        echo -e "  ${ROJO}⚠ ADVERTENCIA: Memoria supera el 85%${NC}"
        log "ALERTA: Memoria crítica ${USO_MEM}%"
    fi
}

# ── DISCO ────────────────────────────────────────────────────
check_disco() {
    seccion "USO DE DISCO"
    df -h | grep -E "^/dev|^Filesystem" | awk '{printf "  %-20s %-8s %-8s %-6s %s\n", $1, $2, $3, $5, $6}'
    USO_DISCO=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
    log "Disco /: ${USO_DISCO}%"
    if [ "$USO_DISCO" -gt 85 ]; then
        echo -e "  ${ROJO}⚠ ADVERTENCIA: Disco / supera el 85%${NC}"
        log "ALERTA: Disco crítico ${USO_DISCO}%"
    fi
}

# ── UPTIME ───────────────────────────────────────────────────
check_uptime() {
    seccion "TIEMPO EN LÍNEA"
    echo -e "  $(uptime -p)"
    log "Uptime: $(uptime -p)"
}

# ── DOCKER ───────────────────────────────────────────────────
check_docker() {
    seccion "ESTADO DE CONTENEDORES DOCKER"
    CONTENEDORES=("web-apache" "mysql-db" "ntp-chrony" "file-server")
    for ct in "${CONTENEDORES[@]}"; do
        STATUS=$(docker inspect -f '{{.State.Status}}' "$ct" 2>/dev/null)
        HEALTH=$(docker inspect -f '{{.State.Health.Status}}' "$ct" 2>/dev/null)
        if [ "$STATUS" = "running" ]; then
            HEALTH_STR=""
            [ -n "$HEALTH" ] && HEALTH_STR=" (health: $HEALTH)"
            echo -e "  ${VERDE} $ct — running${HEALTH_STR}${NC}"
            log "Docker $ct: running $HEALTH_STR"
        else
            echo -e "  ${ROJO} $ct — ${STATUS:-no encontrado}${NC}"
            log "ALERTA Docker $ct: ${STATUS:-no encontrado}"
        fi
    done
}

# ── RAID ─────────────────────────────────────────────────────
check_raid() {
    seccion "ESTADO DE RAID"
    if [ -f /proc/mdstat ]; then
        grep -E "md[0-9]|active|degraded" /proc/mdstat | sed 's/^/  /'
        if grep -q "degraded" /proc/mdstat; then
            echo -e "  ${ROJO}⚠ ADVERTENCIA: RAID degradado${NC}"
            log "ALERTA: RAID degradado"
        else
            echo -e "  ${VERDE} RAID operativo${NC}"
            log "RAID: operativo"
        fi
    else
        echo -e "  ${AMARILLO}ℹ /proc/mdstat no disponible${NC}"
    fi
}

# ── MAIN ─────────────────────────────────────────────────────
encabezado
check_cpu
check_memoria
check_disco
check_uptime
check_docker
check_raid

echo -e "\n${AZUL}══════════════════════════════════════════════════${NC}"
echo -e "  Log guardado en: $LOG_FILE"
echo -e "${AZUL}══════════════════════════════════════════════════${NC}\n"

exit 0

# 📊 Monitoreo y Logs — Ministerio del Trabajo

## Herramientas Utilizadas

| Herramienta | Función |
|-------------|---------|
| `top` | Procesos en tiempo real, CPU y RAM |
| `htop` | Monitoreo interactivo avanzado |
| `journalctl` | Logs del sistema (systemd) |
| `docker logs` | Logs de contenedores individuales |
| `df -h` | Uso de almacenamiento |
| `free -h` | Uso de memoria RAM |

---

## Comandos de Monitoreo

### top — Procesos en tiempo real
```bash
top
# Ver solo procesos Docker:
top -p $(pgrep -d',' docker)
```

### htop — Monitor interactivo
```bash
sudo apt install htop -y
htop
```

### journalctl — Logs del sistema

```bash
# Logs de Apache (contenedor)
sudo journalctl -u docker -n 50 --no-pager | grep web-apache

# Logs de MySQL
docker logs mysql-db --tail 50

# Logs de NTP
docker logs ntp-chrony --tail 30

# Logs de Samba
docker logs file-server --tail 30

# Seguir logs en tiempo real
docker logs -f web-apache
```

### Recursos del sistema
```bash
# Disco
df -h

# RAM
free -h

# Consumo por contenedor
docker stats --no-stream
```

---

## Script de Monitoreo Automático

Ver `scripts/monitoreo.sh` — Revisa CPU, RAM, disco, uptime, RAID y estado de contenedores Docker con alertas por colores y log en `/var/log/mintrabajo/monitoreo.log`.

```bash
chmod +x scripts/monitoreo.sh
sudo ./scripts/monitoreo.sh
```

---

## Estado de Salud de Contenedores

Con los healthchecks configurados en `docker-compose.yml`:

```bash
# Ver estado de salud
docker ps --format "table {{.Names}}\t{{.Status}}"

# Inspeccionar healthcheck
docker inspect web-apache --format='{{.State.Health.Status}}'
```

Posibles estados: `starting` → `healthy` → (si falla) `unhealthy`

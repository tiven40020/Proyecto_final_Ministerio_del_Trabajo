#  Bitácora — Proyecto Final Infraestructura TI
## Ministerio del Trabajo | Maycol Cárdenas Acevedo

---

### Semana 1 — Diseño de Red

**Actividades realizadas:**
- Diseño de la topología de red en Cisco Packet Tracer
- Definición de VLANs: VLAN 10 (DMZ) y VLAN 20 (Red Interna)
- Asignación de direccionamiento IP estático a todos los dispositivos
- Configuración de Router-on-a-Stick en interfaz g0/0
- Pruebas de conectividad (ping entre VLANs y al gateway)

**Problemas encontrados:**
- La subinterfaz del router no enrutaba entre VLANs → Solución: faltaba el comando `encapsulation dot1Q` antes de asignar la IP.
- El trunk no pasaba tráfico → Solución: el puerto del switch hacia el router debía ser `switchport mode trunk`.

**Resultado:**  Topología completa y conectividad verificada entre ambas VLANs.

---

### Semana 2 — Implementación de Servicios Docker

**Actividades realizadas:**
- Instalación y verificación de Docker y Docker Compose
- Creación de la estructura de carpetas del proyecto
- Creación de Dockerfiles para Apache+PHP y NTP-Chrony
- Creación del archivo maestro `docker-compose.yml`
- Pruebas individuales de cada contenedor

**Problemas encontrados:**
- El contenedor web-apache no se conectaba a MySQL → Solución: agregar `depends_on` con `condition: service_healthy` y esperar el healthcheck de MySQL.
- Samba no listaba el recurso compartido → Solución: revisar el parámetro `-s` del comando de `dperson/samba`.

**Resultado:**  4 contenedores activos: web-apache, mysql-db, ntp-chrony, file-server.

---

### Semana 3 — RAID y LVM

**Actividades realizadas:**
- Agregado de 6 discos virtuales a la máquina
- Creación de RAID 1 en md0 (sdb + sdc) y md1 (sdd + sde)
- Creación de Volúmenes Físicos (PVs) sobre md0 y md1
- Creación del Grupo de Volúmenes `disR`
- Creación del Volumen Lógico `lvm_mintrabajo` (3 GB)
- Formateo con ext4 y montaje en `/contenedor1`
- Configuración de montaje persistente en `/etc/fstab`
- Migración del proyecto Docker al nuevo volumen LVM

**Problemas encontrados:**
- `mdadm` no reconocía los discos nuevos → Solución: reiniciar la VM para que el kernel reconociera los dispositivos.
- El montaje no sobrevivía reinicios → Solución: agregar la entrada correcta en `/etc/fstab` con el UUID del LV.

**Resultado:**  RAID 1 operativo, LVM montado en `/contenedor1`, proyecto migrado.

---

### Semana 4 — Seguridad

**Actividades realizadas:**
- Configuración de UFW: políticas deny incoming / allow outgoing
- Apertura de puertos necesarios (22, 80, 443, 139, 445, 123/udp)
- Bloqueo de MySQL desde el exterior (puerto 3306)
- Creación de usuarios: admin_mintrabajo, backups_mintrabajo, monitoreo_mintrabajo
- Creación del grupo `mintrabajo-admins`
- Aplicación de SETUID, SETGID y Sticky Bit en directorios compartidos

**Problemas encontrados:**
- UFW bloqueaba el acceso SSH al activarse → Solución: agregar `ufw allow 22/tcp` **antes** de `ufw enable`.

**Resultado:**  Firewall activo, usuarios creados, permisos especiales configurados.

---

### Semana 5 — Scripts, Monitoreo y Alta Disponibilidad

**Actividades realizadas:**
- Creación de scripts Bash: backup.sh, monitoreo.sh, despliegue.sh
- Pruebas de ejecución y verificación de logs
- Revisión de logs con `journalctl`, `docker logs` y `top/htop`
- Configuración de `restart: always` y healthchecks en docker-compose.yml
- Habilitación de Docker en arranque con `systemctl enable docker`
- Creación del servicio `mintrabajo.service` en systemd para arranque automático

**Problemas encontrados:**
- El healthcheck del contenedor web fallaba → Solución: instalar `curl` dentro del Dockerfile de Apache.
- El servicio systemd no encontraba docker-compose → Solución: especificar la ruta absoluta en el archivo `.service`.

**Resultado:**  Scripts funcionales, monitoreo activo, alta disponibilidad configurada.

---

### Resumen de Validaciones

| Componente | Estado |
|------------|--------|
| Diseño de red (Packet Tracer) |  Completado |
| Servicios Docker (Web, DB, NTP, Samba) | Completado |
| RAID 1 + LVM |  Completado |
| Firewall UFW + Usuarios + Permisos |  Completado |
| Scripts Bash (backup, monitoreo, despliegue) |  Completado |
| Monitoreo (top, htop, journalctl, docker logs) |  Completado |
| Alta disponibilidad (restart, healthcheck, systemd) |  Completado |

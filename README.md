# 🏛️ Infraestructura TI — Ministerio del Trabajo

Proyecto final de **Administración de Infraestructura TI**. Diseño e implementación de una infraestructura tecnológica funcional, segura y escalable para el Ministerio del Trabajo.

---

## 📁 Estructura del Repositorio

```
mintrabajo-infra/
├── docs/                        # Documentación técnica
│   ├── arquitectura.md
│   ├── direccionamiento-ip.md
│   └── bitacora.md
├── network/                     # Configuración de red
│   └── topologia.md             # Descripción de VLANs y Router-on-a-Stick
├── services/                    # Servicios implementados
│   ├── web-apache/              # Servidor web Apache + PHP
│   │   ├── Dockerfile
│   │   ├── html/index.html
│   │   └── php/index.php
│   ├── ntp/                     # Servidor de tiempo Chrony
│   │   ├── Dockerfile
│   │   └── chrony.conf
│   ├── db/                      # Base de datos MySQL
│   │   └── init.sql
│   └── files/                   # Servidor de archivos Samba
│       └── compartido/README.txt
├── docker/                      # Orquestación Docker
│   └── docker-compose.yml
├── scripts/                     # Scripts de automatización Bash
│   ├── backup.sh
│   ├── monitoreo.sh
│   └── despliegue.sh
├── security/                    # Configuración de seguridad
│   └── ufw-rules.md
└── monitoring/                  # Logs y monitoreo
    └── herramientas.md
```

---

## 🏗️ Arquitectura

| Segmento | VLAN | Red | Descripción |
|----------|------|-----|-------------|
| DMZ | VLAN 10 | 192.168.10.0/24 | Servicios públicos (Web, NTP) |
| Red Interna | VLAN 20 | 192.168.20.0/24 | Servicios críticos (DB, Archivos, Admin) |

### Servidores

| Servidor | IP | VLAN | Función |
|----------|----|------|---------|
| Web-Apache | 192.168.10.10 | DMZ | Portal web institucional |
| NTP-Chrony | 192.168.10.20 | DMZ | Sincronización horaria |
| MySQL-DB | 192.168.20.10 | Interna | Base de datos |
| File-Server | 192.168.20.20 | Interna | Archivos compartidos (Samba) |
| Admin-SSH | 192.168.20.100 | Interna | Administración remota |

---

## 🚀 Despliegue Rápido

```bash
# 1. Clonar el repositorio
git clone https://github.com/tu-usuario/mintrabajo-infra.git
cd mintrabajo-infra

# 2. Levantar todos los servicios
cd docker
sudo docker-compose up -d

# 3. Verificar estado
sudo docker-compose ps
```

---

## 🛠️ Tecnologías Utilizadas

- **Virtualización / Contenedores:** Docker, Docker Compose
- **Servicios:** Apache2, MySQL, Chrony NTP, Samba
- **Almacenamiento:** RAID 1 (md0, md1), LVM
- **Seguridad:** UFW, SSH, SETUID, SETGID, Sticky Bit
- **Red:** VLANs, Router-on-a-Stick (Cisco Packet Tracer)
- **Automatización:** Scripts Bash
- **Monitoreo:** top, htop, journalctl, docker logs

---

## 👤 Autor

**Maycol Cárdenas Acevedo**  
Proyecto Final — Administración de Infraestructura TI

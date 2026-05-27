#  Seguridad — Configuración Firewall UFW

## Políticas por Defecto

```bash
sudo ufw default deny incoming   # Bloquear todo lo entrante
sudo ufw default allow outgoing  # Permitir salidas
```

## Reglas Permitidas

| Puerto | Protocolo | Servicio | Política |
|--------|-----------|----------|----------|
| 22     | TCP | SSH | Permitido (solo red interna 192.168.20.0/24) |
| 80     | TCP | HTTP — Apache | Permitido externamente |
| 443    | TCP | HTTPS | Permitido externamente |
| 139    | TCP | Samba NetBIOS | Solo usuarios autorizados |
| 445    | TCP | Samba SMB | Solo usuarios autorizados |
| 123    | UDP | NTP | Permitido para sincronización |
| 3306   | TCP | MySQL | **Bloqueado desde exterior** |

## Comandos Aplicados

```bash
# Permitir SSH
sudo ufw allow 22/tcp

# Permitir HTTP y HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Permitir Samba
sudo ufw allow 139/tcp
sudo ufw allow 445/tcp

# Permitir NTP
sudo ufw allow 123/udp

# Bloquear MySQL desde el exterior
sudo ufw deny 3306/tcp

# Activar UFW
sudo ufw enable

# Verificar reglas
sudo ufw status verbose
```

---

## Gestión de Usuarios

### Usuarios creados

| Usuario | Rol | Grupo |
|---------|-----|-------|
| `admin_mintrabajo` | Administrador principal | `mintrabajo-admins` |
| `backups_mintrabajo` | Gestión de respaldos | `mintrabajo-admins` |
| `monitoreo_mintrabajo` | Supervisión del sistema | `mintrabajo-admins` |

```bash
# Crear usuarios
sudo useradd -m -s /bin/bash admin_mintrabajo
sudo useradd -m -s /bin/bash backups_mintrabajo
sudo useradd -m -s /bin/bash monitoreo_mintrabajo

# Crear grupo
sudo groupadd mintrabajo-admins

# Agregar al grupo
sudo usermod -aG mintrabajo-admins admin_mintrabajo
sudo usermod -aG mintrabajo-admins backups_mintrabajo
sudo usermod -aG mintrabajo-admins monitoreo_mintrabajo
```

---

## Permisos Especiales

### SETUID
Permite ejecutar un binario con permisos del propietario.
```bash
sudo chmod u+s /usr/local/bin/mintrabajo-tool
# Verificar: ls -la /usr/local/bin/mintrabajo-tool
# Resultado: -rwsr-xr-x (la 's' indica SETUID)
```

### SETGID
Los archivos creados dentro del directorio heredan el grupo del padre.
```bash
sudo mkdir -p /srv/compartido/mintrabajo
sudo chgrp mintrabajo-admins /srv/compartido/mintrabajo
sudo chmod g+s /srv/compartido/mintrabajo
# Verificar: drwxr-sr-x (la 's' indica SETGID)
```

### Sticky Bit
Evita que usuarios eliminen archivos ajenos en directorios compartidos.
```bash
sudo chmod +t /srv/compartido/mintrabajo
# Verificar: drwxr-sr-t (la 't' indica Sticky Bit)
```

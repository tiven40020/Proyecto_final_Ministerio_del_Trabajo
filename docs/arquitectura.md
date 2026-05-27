# 🏗️ Arquitectura de la Infraestructura — Ministerio del Trabajo

## Modelo de Segmentación

La infraestructura se divide en dos segmentos principales separados por VLANs:

```
Internet
    │
    ▼
┌─────────────────────────────────────────────┐
│               ROUTER CENTRAL                │
│         (Router-on-a-Stick g0/0)            │
│   Sub-IF g0/0.10 ─── Sub-IF g0/0.20        │
└────────┬────────────────────┬───────────────┘
         │                    │
         ▼                    ▼
┌─────────────────┐   ┌─────────────────────┐
│   DMZ (VLAN 10) │   │ Red Interna (VLAN20)│
│  192.168.10.0/24│   │  192.168.20.0/24    │
│                 │   │                     │
│  ┌───────────┐  │   │  ┌───────────────┐  │
│  │Web-Apache │  │   │  │   MySQL-DB    │  │
│  │.10.10     │  │   │  │   .20.10      │  │
│  └───────────┘  │   │  └───────────────┘  │
│  ┌───────────┐  │   │  ┌───────────────┐  │
│  │NTP-Chrony │  │   │  │  File-Server  │  │
│  │.10.20     │  │   │  │  .20.20       │  │
│  └───────────┘  │   │  └───────────────┘  │
│                 │   │  ┌───────────────┐  │
│                 │   │  │  Admin-SSH    │  │
│                 │   │  │  .20.100      │  │
│                 │   │  └───────────────┘  │
└─────────────────┘   └─────────────────────┘
```

## Justificaciones Técnicas

### DMZ (VLAN 10)
- **Web-Apache** en DMZ porque recibe conexiones externas desde Internet. Aislarlo protege la red interna.
- **NTP-Chrony** en DMZ para que múltiples segmentos puedan sincronizar tiempo de forma centralizada.

### Red Interna (VLAN 20)
- **MySQL-DB** en red interna para proteger datos sensibles de accesos externos directos.
- **File-Server** en red interna para garantizar control de acceso sobre documentación institucional.
- **Admin-SSH** en red interna para que la administración solo sea posible desde dentro.

## Tecnologías

| Capa | Tecnología |
|------|------------|
| Red | VLANs, Router-on-a-Stick (Cisco IOS) |
| Contenedores | Docker, Docker Compose |
| Web | Apache2 + PHP 8.2 + mysqli |
| Base de datos | MySQL 8.0 |
| Tiempo | Chrony (NTP) |
| Archivos | Samba |
| Almacenamiento | RAID 1 (md0, md1) + LVM |
| Seguridad | UFW, SSH, SETUID, SETGID, Sticky Bit |
| Automatización | Scripts Bash |
| Monitoreo | top, htop, journalctl, docker logs |
| Alta disponibilidad | restart: always, healthchecks, systemd |

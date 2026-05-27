============================================================
  MINISTERIO DEL TRABAJO — Servidor de Archivos Compartidos
  File-Server | VLAN 20 — Red Interna | 192.168.20.20
============================================================

Este directorio es el recurso compartido institucional
administrado mediante Samba en la red interna.

USO:
  - Acceso autorizado únicamente a usuarios del grupo mintrabajo-admins
  - Solo lectura para usuarios de monitoreo
  - Los archivos creados aquí heredan automáticamente
    el grupo del directorio (SETGID activo)

RUTAS DE ACCESO:
  Linux:   smb://192.168.20.20/compartido
  Windows: \\192.168.20.20\compartido

ADMINISTRACIÓN:
  Usuario administrador: admin_mintrabajo
  Usuario backups:       backups_mintrabajo
  Usuario monitoreo:     monitoreo_mintrabajo

NOTA: Los archivos eliminados no se pueden recuperar.
Consulte al administrador para obtener respaldos.
============================================================
Última actualización: 2025

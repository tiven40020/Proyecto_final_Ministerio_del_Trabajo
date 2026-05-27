# 🌐 Direccionamiento IP — Ministerio del Trabajo

## Red DMZ — VLAN 10 | `192.168.10.0/24`

| Dispositivo | Función | Dirección IP | Máscara | Gateway |
|-------------|---------|--------------|---------|---------|
| Router SW-DMZ | Gateway DMZ | 192.168.10.1 | 255.255.255.0 | — |
| Web-Apache | Servidor Web | 192.168.10.10 | 255.255.255.0 | 192.168.10.1 |
| NTP-Chrony | Servidor de tiempo | 192.168.10.20 | 255.255.255.0 | 192.168.10.1 |

## Red Interna — VLAN 20 | `192.168.20.0/24`

| Dispositivo | Función | Dirección IP | Máscara | Gateway |
|-------------|---------|--------------|---------|---------|
| Router SW_INTERNO | Gateway Interno | 192.168.20.1 | 255.255.255.0 | — |
| MySQL-DB | Base de datos | 192.168.20.10 | 255.255.255.0 | 192.168.20.1 |
| File-Server | Archivos compartidos | 192.168.20.20 | 255.255.255.0 | 192.168.20.1 |
| Admin-SSH | Administración remota | 192.168.20.100 | 255.255.255.0 | 192.168.20.1 |

## Configuración Switch (VLAN)

```
VLAN 10 — DMZ:      puertos Fa0/1, Fa0/2
VLAN 20 — Interna:  puertos Fa0/3, Fa0/4, Fa0/5
Trunk:              Gi0/1 (hacia el router)
```

## Configuración Router-on-a-Stick

```
interface g0/0
 no shutdown

interface g0/0.10
 encapsulation dot1Q 10
 ip address 192.168.10.1 255.255.255.0

interface g0/0.20
 encapsulation dot1Q 20
 ip address 192.168.20.1 255.255.255.0
```

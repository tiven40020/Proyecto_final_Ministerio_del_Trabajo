# 🌐 Topología de Red — Ministerio del Trabajo

## Diagrama de Red (Packet Tracer)

La topología fue implementada en **Cisco Packet Tracer** con:
- 1 Router Cisco (técnica Router-on-a-Stick)
- 1 Switch multicapa con 2 VLANs
- 5 servidores distribuidos en 2 segmentos

> 📎 El archivo `.pkt` de Packet Tracer se adjunta por separado en la entrega.

---

## VLANs Configuradas

### VLAN 10 — DMZ
```
switchport access vlan 10
switchport mode access
```

### VLAN 20 — Red Interna
```
switchport access vlan 20
switchport mode access
```

### Puerto Trunk (hacia el Router)
```
switchport mode trunk
switchport trunk allowed vlan 10,20
```

---

## Router-on-a-Stick

Técnica que usa **una sola interfaz física** con múltiples subinterfaces para enrutar entre VLANs.

```
interface g0/0
 no shutdown

interface g0/0.10
 encapsulation dot1Q 10
 ip address 192.168.10.1 255.255.255.0
 description Gateway-DMZ

interface g0/0.20
 encapsulation dot1Q 20
 ip address 192.168.20.1 255.255.255.0
 description Gateway-Interna
```

---

## Pruebas de Conectividad (Ping)

| Origen | Destino | Resultado |
|--------|---------|-----|
| Admin-SSH (.20.100) | Gateway LAN (.20.1) |  OK |
| Admin-SSH (.20.100) | MySQL-DB (.20.10) |  OK |
| Admin-SSH (.20.100) | File-Server (.20.20) |  OK |
| Admin-SSH (.20.100) | Gateway DMZ (.10.1) |  OK |
| Admin-SSH (.20.100) | Web-Apache (.10.10) |  OK |
| Admin-SSH (.20.100) | NTP-Chrony (.10.20) |  OK |

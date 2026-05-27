# Descripción del Diagrama de Red
**Ministerio del Trabajo — Infraestructura TI**

---

## Descripción General

El diagrama representa la infraestructura del Ministerio del Trabajo implementada en Cisco Packet Tracer. Está compuesta por un ISP, un router central, un switch multicapa y cinco servidores distribuidos en dos segmentos de red separados mediante VLANs.

La conexión a Internet se realiza a través del ISP con IP `200.0.1.1/16`. El Router1 conecta al ISP mediante su interfaz G0/1 (`200.0.1.2/16`) y al Switch1 mediante G0/0 en modo trunk 802.1Q, aplicando la técnica **Router-on-a-Stick** para enrutar entre las dos VLANs con subinterfaces lógicas.

---

## VLAN 10 — DMZ (zona desmilitarizada)

**Subred:** `172.16.10.0/21` | **Gateway:** `172.16.10.1` | **Máscara:** `255.255.248.0`

Contiene los servicios que requieren visibilidad desde redes externas. Al estar en una zona aislada, un eventual compromiso de estos servidores no expone directamente la red interna.

| Dispositivo | Dirección IP | Máscara | Función |
|-------------|-------------|---------|---------|
| Router GW-DMZ | 172.16.10.1 | 255.255.248.0 | Gateway VLAN 10 |
| Web-Apache | 172.16.10.10 | 255.255.248.0 | Portal web + API-Trámites (172.16.10.15) |
| NTP-Chrony | 172.16.10.20 | 255.255.248.0 | Sincronización horaria (expansión futura: 172.16.11.0/24) |

---

## VLAN 20 — Red Interna

**Subred:** `172.16.20.0/24` | **Gateway:** `172.16.20.1` | **Máscara:** `255.255.255.0`

Aloja los servicios críticos de la organización. El acceso está restringido únicamente desde la red interna, sin exposición directa a Internet.

| Dispositivo | Dirección IP | Máscara | Función |
|-------------|-------------|---------|---------|
| Router GW-Interna | 172.16.20.1 | 255.255.255.0 | Gateway VLAN 20 |
| MySQL-DB | 172.16.20.10 | 255.255.255.0 | Base de datos institucional |
| File-Server (Samba) | 172.16.20.20 | 255.255.255.0 | Archivos compartidos |
| Admin-SSH | 172.16.20.30 | 255.255.255.0 | Administración remota |

### Segmentos internos por área

| Área | Rango de IPs | Equipos |
|------|-------------|---------|
| Administrativa | 172.16.20.100 – 172.16.20.149 | pc-gerencia, RRHH, Finanzas, Printer-ADM |
| TI | 172.16.20.150 – 172.16.20.199 | Laptop-Infraestructura, PC-Soporte |
| Invitados / Temporales | 172.16.20.200 – 172.16.20.254 | Laptop3, Smartphone0 |

---

## Red de Usuarios Externos

Los ciudadanos, empresas y proveedores acceden a los servicios públicos a través de Internet. Se definen tres segmentos diferenciados:

| Segmento | Red | Dispositivos |
|----------|-----|-------------|
| PC-Ciudadanos | 200.0.10.0/24 | PC-PT |
| Empresa | 200.0.20.0/24 | Laptop-PT |
| Proveedores | 200.0.30.0/24 | Smartphone-PT |

---

## Componentes de Red

**Router1 (Cisco):** aplica Router-on-a-Stick con las subinterfaces `G0/0.10` (Gateway DMZ) y `G0/0.20` (Gateway Interna). La interfaz `G0/1` conecta al ISP.

**Switch1 (Cisco 2960-24TT):** gestiona la separación de tráfico. Los puertos `Fa0/1–Fa0/2` pertenecen a VLAN 10 y los puertos `Fa0/3–Fa0/6` a VLAN 20. El puerto `GigabitEthernet0/1` opera en modo trunk hacia el router.

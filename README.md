# 🛡️ Zeek IDS - Sistema de Detección de Intrusos

Sistema de detección de intrusos basado en Zeek que identifica conexiones a IPs maliciosas en tiempo real.

## ¿Qué detecta?

- **Conexiones a IPs maliciosas** — alerta cuando un host interno se conecta a una IP en la lista negra

## Requisitos

- Ubuntu 24.04 / WSL2
- Zeek 8.x
- Python 3 + Scapy (para generar tráfico de prueba)

## Instalación de Zeek

```bash
echo 'deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_24.04/ /' | sudo tee /etc/apt/sources.list.d/security:zeek.list
curl -fsSL https://download.opensuse.org/repositories/security:/zeek/xUbuntu_24.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null
sudo apt-get update && sudo apt-get install -y zeek
echo 'export PATH=/opt/zeek/bin:$PATH' >> ~/.bashrc && source ~/.bashrc
```

## Uso

**1. Clonar el repositorio:**

```bash
git clone https://github.com/KyleR-08/zeek-ids.git
cd zeek-ids
```

**2. Generar tráfico de prueba:**

```bash
pip3 install scapy --break-system-packages
python3 generar_ataques.py
```

**3. Correr el IDS:**

```bash
zeek -r ataques_simulados.pcap ids_main.zeek -C
```

## Output esperado

```
==============================================
   ZEEK IDS - Sistema iniciado correctamente
   Detectando:
   [1] Conexiones a IPs Maliciosas (Blacklist)
==============================================
[ALERTA - IP MALICIOSA] 192.168.1.10 intentó conectarse a IP en blacklist: 1.2.3.4
[ALERTA - IP MALICIOSA] 192.168.1.10 intentó conectarse a IP en blacklist: 45.33.32.156
==============================================
   ZEEK IDS - Analisis finalizado
==============================================
```

## Archivos

| Archivo | Descripción |
|---|---|
| `ids_main.zeek` | Script principal |
| `blacklist.zeek` | Módulo de detección de IPs maliciosas |
| `generar_ataques.py` | Generador de tráfico de prueba con Scapy |

## IPs en lista negra

| IP | Clasificación |
|---|---|
| 1.2.3.4 | IP maliciosa conocida |
| 5.6.7.8 | IP maliciosa conocida |
| 10.0.0.99 | IP interna sospechosa |
| 192.168.1.254 | Gateway sospechoso |
| 45.33.32.156 | IP pública maliciosa |
| 198.20.99.130 | IP pública maliciosa |

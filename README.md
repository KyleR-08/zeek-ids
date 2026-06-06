# Zeek IDS — Sistema de Detección de Intrusos

Sistema de Detección de Intrusos (IDS) construido sobre [Zeek](https://zeek.org/) (antes conocido como Bro), diseñado como proyecto académico para la **Universidad Internacional del Ecuador (UIDE)**. El sistema analiza tráfico de red en tiempo real (o desde archivos PCAP) y genera alertas ante tres tipos de comportamientos sospechosos.

---

## 📋 ¿Qué es este proyecto?

Este proyecto implementa un IDS modular escrito en el lenguaje de scripting de Zeek. Está orientado a fines educativos y demuestra cómo Zeek puede usarse para detectar amenazas comunes sin recurrir a soluciones comerciales pesadas.

### ¿Para qué sirve?

- **Aprender** cómo funciona un IDS basado en análisis de protocolos.
- **Detectar** comportamientos maliciosos en tráfico de red capturado o en vivo.
- **Generar alertas** legibles por humanos en stdout / logs de Zeek.
- **Servir como base** para extender con nuevas reglas de detección.

### Amenazas detectadas

| # | Amenaza | Script |
|---|---------|--------|
| 1 | Port Scanning (escaneo de puertos) | `port_scan.zeek` |
| 2 | SSH Brute Force (fuerza bruta SSH) | `ssh_bruteforce.zeek` |
| 3 | Conexiones a IPs maliciosas | `blacklist.zeek` |

---

## 🔧 Requisitos

- **Zeek 8.x** (probado en 8.0+)
- **Ubuntu 22.04 / 24.04** o **WSL2 (Ubuntu)** sobre Windows 10/11
- **Git**
- Privilegios `sudo` para instalar paquetes y capturar tráfico en vivo

---

## 📦 Instalación de Zeek (paso a paso)

### Opción A — Instalación desde repositorio oficial (recomendada)

```bash
# 1. Importar la llave GPG del repositorio de Zeek
echo 'deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_24.04/ /' | \
    sudo tee /etc/apt/sources.list.d/security:zeek.list

curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_24.04/Release.key | \
    gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null

# 2. Actualizar e instalar Zeek
sudo apt update
sudo apt install -y zeek

# 3. Añadir Zeek al PATH
echo 'export PATH=/opt/zeek/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# 4. Verificar la instalación
zeek --version
```

> 💡 Si usas Ubuntu 22.04, cambia `xUbuntu_24.04` por `xUbuntu_22.04` en los pasos anteriores.

### Opción B — Compilación desde código fuente

```bash
sudo apt install -y cmake make gcc g++ flex bison libpcap-dev libssl-dev \
    python3 python3-dev swig zlib1g-dev

git clone --recursive https://github.com/zeek/zeek
cd zeek
./configure
make -j$(nproc)
sudo make install
```

---

## 🚀 Clonar y ejecutar este proyecto

### 1. Clonar el repositorio

```bash
git clone https://github.com/KyleR-08/zeek-ids.git
cd zeek-ids
```

### 2. Ejecutar sobre un archivo PCAP

```bash
zeek -r captura.pcap ids_main.zeek
```

### 3. Ejecutar en una interfaz de red en vivo

```bash
sudo zeek -i eth0 ids_main.zeek
```

> Reemplaza `eth0` por tu interfaz real (usa `ip a` para listarlas).

### 4. Generar tráfico de prueba (opcional)

Puedes simular un port scan desde otra máquina con `nmap`:

```bash
nmap -sS -p 1-1000 <IP_destino>
```

---

## 🛡️ Detalle de cada script

### 1. `port_scan.zeek` — Detección de escaneo de puertos

Cuenta cuántos puertos distintos ha tocado cada IP origen. Si supera el umbral (**10 puertos**), emite una alerta.

**Variables clave:**
- `scan_threshold = 10` — número de puertos antes de alertar
- `scan_table` — tabla `addr → set[port]` que registra los puertos vistos por IP

**Ejemplo de salida:**
```
[ALERTA - PORT SCAN] IP sospechosa: 192.168.1.50 ha escaneado 11 puertos
[ALERTA - PORT SCAN] IP sospechosa: 192.168.1.50 ha escaneado 12 puertos
```

---

### 2. `ssh_bruteforce.zeek` — Detección de fuerza bruta SSH

Cuenta los intentos de conexión al puerto `22/tcp` por IP origen. Si superan el umbral (**5 intentos**), emite una alerta con cooldown de **60 segundos** para evitar spam.

**Variables clave:**
- `ssh_threshold = 5` — intentos antes de alertar
- `ssh_attempts` — contador por IP
- `ssh_last_alert` — timestamp de la última alerta por IP (cooldown)

**Ejemplo de salida:**
```
[ALERTA - SSH BRUTE FORCE] IP: 10.0.0.42 lleva 6 intentos al puerto 22
[ALERTA - SSH BRUTE FORCE] IP: 10.0.0.42 lleva 23 intentos al puerto 22
```

---

### 3. `blacklist.zeek` — Conexiones a IPs maliciosas

Compara la IP destino de cada conexión nueva contra una lista negra. Si hay coincidencia, alerta.

**Lista negra incluida (ejemplo):**
```
1.2.3.4, 5.6.7.8, 10.0.0.99,
192.168.1.254, 45.33.32.156, 198.20.99.130
```

**Ejemplo de salida:**
```
[ALERTA - IP MALICIOSA] 192.168.1.10 intentó conectarse a IP en blacklist: 45.33.32.156
```

---

### 4. `ids_main.zeek` — Orquestador principal

Carga los tres módulos anteriores e imprime banners de inicio y cierre:

```
==============================================
   ZEEK IDS - Sistema iniciado correctamente
   Detectando:
   [1] Port Scanning
   [2] SSH Brute Force
   [3] Conexiones a IPs Maliciosas
==============================================
```

---

## 📁 Estructura del proyecto

```
zeek-ids/
├── ids_main.zeek          # Punto de entrada — carga los demás módulos
├── port_scan.zeek         # Detección de escaneo de puertos
├── ssh_bruteforce.zeek    # Detección de fuerza bruta SSH
├── blacklist.zeek         # Detección de IPs maliciosas
└── README.md              # Este archivo
```

---

## 🧪 Probar sin tráfico real

Puedes descargar un PCAP de ejemplo y ejecutar el IDS sobre él:

```bash
wget https://www.bro.org/static/traces/exercise-traffic.pcap
zeek -r exercise-traffic.pcap ids_main.zeek
```

---

## 📚 Recursos

- [Documentación oficial de Zeek](https://docs.zeek.org/)
- [Zeek Scripting Reference](https://docs.zeek.org/en/master/script-reference/index.html)
- [Try Zeek (sandbox online)](https://try.zeek.org/)

---

## 👨‍🎓 Autor

Proyecto académico — **Universidad Internacional del Ecuador (UIDE)**
Tercer semestre — Seguridad de Redes

---

## 📄 Licencia

Distribuido con fines educativos. Libre de usar y modificar para aprendizaje.

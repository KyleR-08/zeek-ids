from scapy.all import *

paquetes = []

# 1. PORT SCAN - conexiones completas a 15 puertos
for puerto in [21,22,23,25,80,443,8080,3306,5432,6379,27017,8443,9200,4444,1337]:
    paquetes.append(IP(src="10.0.0.50", dst="192.168.1.1")/TCP(sport=12345, dport=puerto, flags="S", seq=100))
    paquetes.append(IP(src="192.168.1.1", dst="10.0.0.50")/TCP(sport=puerto, dport=12345, flags="SA", seq=200, ack=101))
    paquetes.append(IP(src="10.0.0.50", dst="192.168.1.1")/TCP(sport=12345, dport=puerto, flags="A", seq=101, ack=201))

# 2. SSH BRUTE FORCE - 10 conexiones completas al puerto 22
for i in range(10):
    sport = 50000 + i
    paquetes.append(IP(src="10.0.0.99", dst="192.168.1.1")/TCP(sport=sport, dport=22, flags="S", seq=100))
    paquetes.append(IP(src="192.168.1.1", dst="10.0.0.99")/TCP(sport=22, dport=sport, flags="SA", seq=200, ack=101))
    paquetes.append(IP(src="10.0.0.99", dst="192.168.1.1")/TCP(sport=sport, dport=22, flags="A", seq=101, ack=201))

# 3. IP MALICIOSA
paquetes.append(IP(src="192.168.1.10", dst="1.2.3.4")/TCP(sport=54321, dport=80, flags="S", seq=100))
paquetes.append(IP(src="1.2.3.4", dst="192.168.1.10")/TCP(sport=80, dport=54321, flags="SA", seq=200, ack=101))
paquetes.append(IP(src="192.168.1.10", dst="1.2.3.4")/TCP(sport=54321, dport=80, flags="A", seq=101, ack=201))
paquetes.append(IP(src="192.168.1.10", dst="45.33.32.156")/TCP(sport=54322, dport=443, flags="S", seq=100))
paquetes.append(IP(src="45.33.32.156", dst="192.168.1.10")/TCP(sport=443, dport=54322, flags="SA", seq=200, ack=101))
paquetes.append(IP(src="192.168.1.10", dst="45.33.32.156")/TCP(sport=54322, dport=443, flags="A", seq=101, ack=201))

wrpcap("ataques_simulados.pcap", paquetes)
print(f"pcap generado con {len(paquetes)} paquetes")

# ============================================
# ZEEK IDS - Sistema de Detección de Intrusos
# Detecta: Port Scanning, SSH Brute Force, IPs Maliciosas
# ============================================

@load ./port_scan
@load ./ssh_bruteforce
@load ./blacklist

event zeek_init()
    {
    print "==============================================";
    print "   ZEEK IDS - Sistema iniciado correctamente  ";
    print "   Detectando:                                ";
    print "   [1] Port Scanning                          ";
    print "   [2] SSH Brute Force                        ";
    print "   [3] Conexiones a IPs Maliciosas            ";
    print "==============================================";
    }

event zeek_done()
    {
    print "==============================================";
    print "   ZEEK IDS - Análisis finalizado             ";
    print "==============================================";
    }

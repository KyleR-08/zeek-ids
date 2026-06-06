# ============================================
# ZEEK IDS - Sistema de Detección de Intrusos
# Detecta: Conexiones a IPs Maliciosas
# ============================================
@load ./blacklist
event zeek_init()
    {
    print "==============================================";
    print "   ZEEK IDS - Sistema iniciado correctamente  ";
    print "   Detectando:                                ";
    print "   [1] Conexiones a IPs Maliciosas (Blacklist)";
    print "==============================================";
    }
event zeek_done()
    {
    print "==============================================";
    print "   ZEEK IDS - Analisis finalizado             ";
    print "==============================================";
    }

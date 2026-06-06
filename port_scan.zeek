# IDS - Detección de Port Scanning
# Si una IP intenta conectarse a más de 10 puertos distintos en poco tiempo, es un scan

global scan_threshold = 10;
global scan_table: table[addr] of set[port] &default=set();

event new_connection(c: connection)
    {
    local src = c$id$orig_h;
    local dst_port = c$id$resp_p;

    add scan_table[src][dst_port];

    if ( |scan_table[src]| > scan_threshold )
        {
        print fmt("[ALERTA - PORT SCAN] IP sospechosa: %s ha escaneado %d puertos", 
                  src, |scan_table[src]|);
        }
    }

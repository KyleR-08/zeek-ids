# IDS - Detección de conexiones a IPs en lista negra
# Si alguien se conecta a una IP conocida como maliciosa, genera alerta

global blacklist: set[addr] = {
    1.2.3.4,
    5.6.7.8,
    10.0.0.99,
    192.168.1.254,
    45.33.32.156,
    198.20.99.130
};

event new_connection(c: connection)
    {
    local dst = c$id$resp_h;
    local src = c$id$orig_h;

    if ( dst in blacklist )
        {
        print fmt("[ALERTA - IP MALICIOSA] %s intentó conectarse a IP en blacklist: %s",
                  src, dst);
        }
    }

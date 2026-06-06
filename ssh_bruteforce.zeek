# IDS - Detección de Fuerza Bruta SSH
# Si una IP hace más de 5 intentos de conexión SSH en poco tiempo, es fuerza bruta

global ssh_threshold = 5;
global ssh_attempts: table[addr] of count &default=0;
global ssh_last_alert: table[addr] of time &default=double_to_time(0.0);

event connection_attempt(c: connection)
    {
    if ( c$id$resp_p == 22/tcp )
        {
        local src = c$id$orig_h;
        ssh_attempts[src] += 1;

        if ( ssh_attempts[src] > ssh_threshold )
            {
            local now = network_time();
            if ( now - ssh_last_alert[src] > 60 secs )
                {
                print fmt("[ALERTA - SSH BRUTE FORCE] IP: %s lleva %d intentos al puerto 22",
                          src, ssh_attempts[src]);
                ssh_last_alert[src] = now;
                }
            }
        }
    }

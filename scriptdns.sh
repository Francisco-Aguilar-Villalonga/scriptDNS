#!/bin/bash
#Script de configuración DNS Grup1

apt update && apt install -y bind9 bind9utils bind9-doc

BIND_CONFIG="/etc/bind/named.conf.local"

#Zona programaciocor.com
cat <<EOT > /etc/bind/db.programaciocor.com
\$TTL 1M
@   IN  SOA ns01.programaciocor.com. admin.programaciocor.com. (
    2008052001
    120
    60
    86400
    60 )
@   IN  NS  ns01.programaciocor.com.
@   IN  NS  ns02.programaciocor.com.
@   IN  MX  10 mail01.programaciocor.com.
@   IN  MX  20 mail02.programaciocor.com.
www IN  CNAME web.programaciocor.com.
ftp IN  CNAME file.programaciocor.com.
ns01 IN  A 192.168.144.24
ns02 IN  A 192.168.144.25
mail01 IN A 192.168.144.26
mail02 IN A 192.168.144.27
web IN A 192.168.144.28
file IN A 192.168.144.29
EOT

#Subzona estacions.programaciocor.com
cat <<EOT > /etc/bind/db.estacions.programaciocor.com
\$TTL 1M
@   IN  SOA ns01.programaciocor.com. admin.programaciocor.com. (
    2008052001
    120
    60
    86400
    60 )
@   IN  NS  ns01.programaciocor.com.
@   IN  NS  ns02.programaciocor.com.
est01 IN  A 10.18.144.2
est02 IN  A 10.18.144.3
est03 IN  A 10.18.144.4
est04 IN  A 10.18.144.5
est05 IN  A 10.18.144.6
EOT

#Zona inversa 10.18.144
cat <<EOT > /etc/bind/db.10.18.144
\$TTL 1M
@   IN  SOA ns01.programaciocor.com. admin.programaciocor.com. (
    2008052001
    120
    60
    86400
    60 )
@   IN  NS  ns01.programaciocor.com.
@   IN  NS  ns02.programaciocor.com.
2   IN  PTR est01.programaciocor.com.
3   IN  PTR est02.programaciocor.com.
4   IN  PTR est03.programaciocor.com.
5   IN  PTR est04.programaciocor.com.
6   IN  PTR est05.programaciocor.com.
EOT

cat <<EOT >> $BIND_CONFIG

zone "programaciocor.com" {
    type master;
    file "/etc/bind/db.programaciocor.com";
};

zone "estacions.programaciocor.com" {
    type master;
    file "/etc/bind/db.estacions.programaciocor.com";
};

zone "144.18.10.in-addr.arpa" {
    type master;
    file "/etc/bind/db.10.18.144";
};
EOT

systemctl restart bind9
systemctl enable bind9

#!/bin/bash
ODOOUSER="odoo"
DBUSER="odoo"
DBPASS="abc123."

#Creamos el archivo de log y cambiamos propietario
[ -d /var/log/odoo ] || mkdir /var/log/odoo
touch /var/log/odoo/odoo.log
chown -R $ODOOUSER:$ODOOUSER /var/log/odoo

#Arranca odoo (while: la primera vez no arranca bien)
while [[ ! $(service odoo.sh start) ]];do continue;done

#Cambiamos propietario del filestore
[ $(stat -c "%G" /opt/odoo/.local) == "odoo" ] || chown -R odoo:odoo /opt/odoo/.local

#Arrancamos servicios
service postgresql start

#Crea el usuario odoo en postgres
su - postgres -c "createuser --createdb $DBUSER" && su - postgres -c "psql -c \"alter role $DBUSER with password '$DBPASS'\""

#Escribe en /etc/hosts para que resuelva postgres al localhost
echo "127.0.0.1 postgres" >> /etc/hosts

#Uso exec para lanzar un proceso independiente de bucle infinito
exec bash -c "while true;do sleep 10;done"


#!/bin/bash
ODOOUSER="odoo"
ODOOPASS="abc123."

#Arrancamos servicios
service postgresql start

#Creamos el archivo de log y cambiamos propietario
[ -d /var/log/odoo ] || mkdir /var/log/odoo
touch /var/log/odoo/odoo.log
chown -R $ODOOUSER:$ODOOUSER /var/log/odoo

#Crea el usuario odoo en postgres
su - postgres -c "createuser --createdb $ODOOUSER" && su - postgres -c "psql -c \"alter role $ODOOUSER with password '$ODOOPASS'\""

#Escribe en /etc/hosts para que resuelva postgres al localhost
echo "127.0.0.1 postgres" >> /etc/hosts

#Cambiamos la ruta al daemon del script
sed -i 's/OCBDIR/OCB/' /etc/init.d/odoo.sh

#Arranca odoo (while: la primera vez no arranca bien)
while [[ ! $(service odoo.sh start) ]];do continue;done

#Cambiamos propietario del filestore
[ $(stat -c "%G" /opt/odoo/.local) == "odoo" ] || chown -R odoo:odoo /opt/odoo/.local

#Uso exec para lanzar un proceso independiente de bucle infinito
exec bash -c "while true;do sleep 10;done"


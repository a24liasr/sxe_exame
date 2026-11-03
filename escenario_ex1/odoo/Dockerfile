FROM javierfpisc/odoo:v18conpostgres

LABEL maintainer javierfp@iessanclemente.net

#Instalar client postgresql
RUN apt install -y postgresql-client

#Copiamos el entrypoint.sh al container
COPY entrypoint.sh /usr/bin/entrypoint.sh

#Damos permiso al entrypoint
RUN chmod +x /usr/bin/entrypoint.sh

#Copiamos el archivo odoo.conf
COPY odoo.conf /opt/odoo/examen/odoo.conf

#Borramos el odoo.conf de la imagen original
RUN rm /opt/odoo/odoo.conf

#Copiamos el archivo odoo.sh
COPY odoo.sh /opt/odoo/examen/odoo.sh

#Creamos enlace simbólico al script odoo.sh
RUN rm /etc/init.d/odoo.sh && ln -s /opt/odoo/examen/odoo.sh /etc/init.d/odoo.sh

#Comando para arrancar ssh y entrar en bucle de espera
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

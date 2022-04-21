## Contenedores para asterisk 

Contenedor con asterisk instalado, tiene todo lo necesario para correr en la nube y con varios CPU, el codec g729 se puede activar montando el volumen /g729 y almacenando el codec.


## Volumenes:
* /custom: Dentro de este directorio se deben poner los siguientes archivos:
- codec_g729.so: Copia y habilita el codec g729 URL: http://asterisk.hosting.lv/
- ns-start: Reescribe el script de inicio en caso de costumizarlo 

* /etc/asterisk: Archivos de configuracion 
* /var/lib/asterisk: Librerias, sonidos y agis 
* /var/lib/spool: Grabaciones y correos de voz
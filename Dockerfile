FROM --platform=Linux/amd64 ubuntu:20.04 

#Actualizo repositorios 
RUN		    apt-get update; apt-get -y upgrade;mkdir /custom

#Vamos a instalar dependencias para construir asterisk
ARG         DEBIAN_FRONTEND=noninteractive
RUN         apt-get -y install asterisk; \
            rm -rf  /var/lib/asterisk;rm -rf /etc/asterisk;rm -rf /var/spool/asterisk;rm -rf /usr/share/asterisk; \
            mkdir  /etc/asterisk; mkdir /var/lib/asterisk; mkdir /var/spool/asterisk; \
            ln -s /var/lib/asterisk /usr/share/      


        

WORKDIR     /var/lib/asterisk
            

#Inicio del contenedor y salud
COPY        files/ns-start /usr/bin/
COPY        files/healthcheck /usr/bin/
COPY        files/asterisk-etc /opt/asterisk-etc
COPY        files/asterisk-var /opt/asterisk-var
COPY        files/asterisk-spool /opt/asterisk-spool


RUN         chmod +x /usr/bin/ns-start; \
            chmod +x /usr/bin/healthcheck


HEALTHCHECK --interval=120s --timeout=30s --start-period=240s CMD /usr/bin/healthcheck
ENTRYPOINT  [ "/usr/bin/ns-start" ]



            



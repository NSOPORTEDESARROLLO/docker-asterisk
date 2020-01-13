FROM		debian:buster   as builder

#Actualizo repositorios 
RUN		    apt-get update; apt-get -y upgrade

#Vamos a instalar dependencias para construir asterisk
ARG         DEBIAN_FRONTEND=noninteractive
RUN         apt-get -y install wget build-essential  git-core subversion \
            libjansson-dev sqlite autoconf automake libxml2-dev \
            libncurses5-dev libtool aptitude binutils-dev freetds-dev \
            libasound2-dev libbluetooth-dev libcurl4-openssl-dev libedit-dev \
            libgsm1-dev libgtk2.0-dev libical-dev libiksemel-dev libjack-dev \
            liblua5.1-0-dev libneon27-dev libnewt-dev libogg-dev libpopt-dev \
            libpq-dev libsnmp-dev libspandsp-dev libspeex-dev libspeexdsp-dev \
            libsqlite0-dev libsqlite3-dev libssl-dev libusb-dev libvorbis-dev \
            libvpb-dev lua5.1 portaudio19-dev unixodbc-dev uuid \
            uuid-dev unzip default-libmysqlclient-dev



#Descargar el fuente de asterisk 
RUN         wget -P /usr/src "http://downloads.asterisk.org/pub/telephony/certified-asterisk/asterisk-certified-13.21-current.tar.gz"; \
            tar -xzvf /usr/src/asterisk-certified-13.21-current.tar.gz -C /usr/src/
            


WORKDIR     /usr/src/asterisk-certified-13.21-cert6



#Configurando Asterisk
RUN         ./configure --prefix=/opt/asterisk; \
            make menuselect.makeopts; \
            menuselect/menuselect --disable BUILD_NATIVE menuselect.makeopts; \
            menuselect/menuselect --enable chan_ooh323 menuselect.makeopts; \
            menuselect/menuselect --enable chan_mobile menuselect.makeopts; \
            menuselect/menuselect --enable format_mp3 menuselect.makeopts; \
            menuselect/menuselect --enable res_config_mysql menuselect.makeopts; \
            menuselect/menuselect --enable app_mysql menuselect.makeopts; \
            menuselect/menuselect --enable app_saycountpl menuselect.makeopts; \
            menuselect/menuselect --enable cdr_mysql menuselect.makeopts; \
            menuselect/menuselect --enable app_skel menuselect.makeopts; \
            menuselect/menuselect --enable chan_sip menuselect.makeopts; \
            menuselect/menuselect --enable cdr_csv menuselect.makeopts; \
            menuselect/menuselect --enable app_festival menuselect.makeopts; \
            /usr/src/asterisk-certified-13.21-cert6/contrib/scripts/get_mp3_source.sh; \
            #echo -e "yes" | /usr/src/asterisk-certified-13.21-cert6/contrib/scripts/get_ilbc_source.sh

            



RUN         make; \
            make install; \
            make samples; \
            make config; \
            mkdir -p /opt/asterisk/samples; \
            cp -rf /opt/asterisk/etc/asterisk /opt/asterisk/samples/asterisk-etc; \
            cp -rf /opt/asterisk/var/lib/asterisk /opt/asterisk/samples/asterisk-lib; \
            cp -rf /opt/asterisk/var/spool/asterisk /opt/asterisk/samples/asterisk-spool; \            
            rm -rf /opt/asterisk/etc/asterisk/*; \
            rm -rf /opt/asterisk/var/lib/asterisk/*; \
            rm -rf /opt/asterisk/var/spool/asterisk/*






#Ahora empiezo a crear el contenedor con las minimas librerias 
FROM        debian:buster

#Actualizo repositorios 
ARG         DEBIAN_FRONTEND=noninteractive

RUN		    apt-get update; apt-get -y upgrade; \
            apt-get -y install ca-certificates dbus fontconfig fontconfig-config fonts-dejavu-core freetds-common gnupg-agent gnupg2 \
            libalgorithm-c3-perl libarchive-extract-perl libasound2 libasound2-data libassuan0 libatk1.0-0 libatk1.0-data \
            libavahi-client3 libavahi-common-data libavahi-common3 libbsd0 libcairo2 libcap-ng0 libcfg7 libcgi-fast-perl \
            libcgi-pm-perl libclass-c3-perl libclass-c3-xs-perl libcpan-meta-perl libcpg4 libcups2 libcurl4 \
            libcurl3-gnutls libdata-optlist-perl libdata-section-perl libdatrie1 libdbus-1-3 libdns-export1104 libedit2 \
            libexpat1 libfcgi-perl libflac8 libfontconfig1 libfreeradius3 libfreetype6 libgdbm6 libgdk-pixbuf2.0-0 \
            libgdk-pixbuf2.0-common libglib2.0-0 libglib2.0-data libgmime-2.6-0 libgomp1 libgpgme11 libgraphite2-3 libgsm1 \
            libgssapi-krb5-2 libgtk2.0-0 libgtk2.0-bin libgtk2.0-common libharfbuzz0b libical3 libidn11 libiksemel3 \
            libirs-export161 libisc-export1100 libisccfg-export163 libjack-jackd2-0 libjbig0 libjpeg62-turbo libk5crypto3 \
            libkeyutils1 libkrb5-3 libkrb5support0 libksba8 libldap-2.4-2 liblog-message-perl liblog-message-simple-perl libltdl7 \
            liblua5.1-0 libmagic1 libmodule-build-perl libmodule-pluggable-perl libmodule-signature-perl libmro-compat-perl \
            libneon27-gnutls libodbc1 libogg0 libopencore-amrnb0 libopencore-amrwb0 libopus0 libpackage-constants-perl \
            libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libparams-util-perl libpci3 libperl5.28 libpixman-1-0 \
            libpng16-16 libpod-latex-perl libpod-readme-perl libpopt0 \
            libportaudio2 libpq5 libpth20 libregexp-common-perl libresample1 librtmp1 libsamplerate0 libsasl2-2 \
            libsasl2-modules libsasl2-modules-db libsensors-config libsndfile1 libsnmp-base libsnmp30 libsoftware-license-perl \
            libsox-fmt-alsa libsox-fmt-base libsox3 libspandsp2 libspeex1 libspeexdsp1 libsqlite0 libsqlite3-0 libsrtp2-1 \
            libssh2-1 libssl1.1 libsub-exporter-perl libsub-install-perl libsybdb5 libterm-ui-perl libtext-soundex-perl \
            libtext-template-perl libthai-data libthai0 libtiff5 libvorbis0a libvorbisenc2 libvorbisfile3 libwavpack1 \
            libwrap0 libx11-6 libx11-data libxau6 libxcb-render0 libxcb-shm0 libxcb1 libxcomposite1 libxcursor1 libxdamage1 \
            libxdmcp6 libxext6 libxfixes3 libxi6 libxinerama1 libxml2 libxrandr2 libxrender1 netbase openssl \
            perl perl-modules pinentry-gtk2 rename sgml-base shared-mime-info sox tcpd ucf xdg-user-dirs \
            xml-core default-mysql-client libneon27 libbluetooth3 php7.3-cli libjansson4



    
WORKDIR     /opt

#Copio asterisk desde builder
COPY        --from=builder   /opt/asterisk /opt/asterisk

RUN         adduser asterisk --no-create-home --disabled-password --uid 10000; \
            chown -R asterisk.asterisk /opt/asterisk; \
            mkdir /g729

#Creando enlaces para la compatibilidad con NSPBX
RUN         for cmd in $(ls /opt/asterisk/sbin);do ln -s /opt/asterisk/sbin/$cmd /usr/sbin/;done; \
            mv /opt/asterisk/var/log/asterisk /var/log; \
            ln -s /var/log/asterisk /opt/asterisk/var/log/; \
            mv /opt/asterisk/var/lib/asterisk /var/lib/; \
            ln -s /var/lib/asterisk /opt/asterisk/var/lib/; \
            mv /opt/asterisk/var/spool/asterisk /var/spool/; \
            ln -s /var/spool/asterisk /opt/asterisk/var/spool/; \
            mkdir /run/asterisk; \
            mv /opt/asterisk/etc/asterisk /etc/; \
            ln -s /etc/asterisk /opt/asterisk/etc/; \
            mv /opt/asterisk/lib/asterisk /usr/lib/; \
            ln -s /usr/lib/asterisk /opt/asterisk/lib/; \
            ln -s /usr/lib /usr/lib64; \
            chown -R asterisk.asterisk /var/log/asterisk; \
            chown -R asterisk.asterisk /var/lib/asterisk; \
            chown -R asterisk.asterisk /var/spool/asterisk; \
            chown -R asterisk.asterisk /run/asterisk; \
            ln /opt/asterisk/lib/libasteriskssl.so /usr/lib/; \
            ln /opt/asterisk/lib/libasteriskssl.so.1 /usr/lib/




#Inicio del contenedor y salud
COPY        files/ns-start /usr/bin/
COPY        files/healthcheck /usr/bin/


RUN         chmod +x /usr/bin/ns-start; \
            chmod +x /usr/bin/healthcheck


HEALTHCHECK --interval=120s --timeout=30s --start-period=240s CMD /usr/bin/healthcheck
ENTRYPOINT  [ "/usr/bin/ns-start" ]



            



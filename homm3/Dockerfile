FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

RUN dpkg --add-architecture i386 \
    && apt-get update -y && apt-get install -y vnc4server novnc websockify wine

RUN apt-get clean autoclean && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}


RUN cp -R /usr/share/novnc /root/novnc
ADD bin/homm3.reg /root/bin/homm3.reg
ADD bin/index.html /root/novnc/
ADD bin/xstartup /root/.vnc/xstartup
ADD bin/start-h3.sh /root/bin/start-h3.sh

COPY ["./HoMM3", "/root/.wine/drive_c/Program Files (x86)/3DO/Heroes III Demo"]
WORKDIR /root/.wine/drive_c/Program\ Files\ \(x86\)/3DO/Heroes\ III\ Demo/

EXPOSE 8081
CMD /root/bin/start-h3.sh

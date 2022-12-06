FROM debian:buster

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=C.UTF-8 DISPLAY=:0.0

# Install dependencies.
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
      bzip2 \
      gstreamer1.0-plugins-good \
      gstreamer1.0-pulseaudio \
      gstreamer1.0-tools \
      libglu1-mesa \
      libgtk2.0-0 \
      libncursesw5 \
      libopenal1 \
      libsdl-image1.2 \
      libsdl-ttf2.0-0 \
      libsdl1.2debian \
      libsndfile1 \
      novnc \
      pulseaudio \
      supervisor \
      ucspi-tcp \
      wget \
      x11vnc \
      xvfb \
 && rm -rf /var/lib/apt/lists/*

# Install Wine.
RUN dpkg --add-architecture i386 \
    && apt-get update -y && apt-get install -y wine

# Configure pulseaudio.
ADD bin/default.pa /etc/pulse/
ADD bin/client.conf /etc/pulse

# Force vnc_lite.html to be used for novnc, to avoid having the directory listing page.
# Additionally, turn off the control bar. Finally, add a hook to start audio on the host where the container is found via its IP address.
# If you use "localhost" instead of IP address, then sound won't work anywhere but on the host. If you use an IP address, it will work on every computer that enters the website (but make sure to open port 8081 on the host's firewall for incoming/outgoing traffic). 
ADD bin/webaudio.js /usr/share/novnc/core/
RUN ln -s /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html \
 && sed -i 's/display:flex/display:none/' /usr/share/novnc/app/styles/lite.css \
 && sed -i "/import RFB/a \
      import WebAudio from './core/webaudio.js'" \
    /usr/share/novnc/vnc_lite.html \
 && sed -i "/function connected(e)/a \
      var wa = new WebAudio('ws://localhost:8081/websockify'); \
      document.getElementsByTagName('canvas')[0].addEventListener('keydown', e => { wa.start(); });" \
    /usr/share/novnc/vnc_lite.html \
 && sed -i "/\/body>/a \
      <footer style=\"text-align:center; background-color:grey;\">Enlarge game's screen by using the browser's zoom-in (CTRL and '+' key). To activate sound, click on the game's screen and press any key on the keyboard.</footer>" \
    /usr/share/novnc/vnc_lite.html

# Configure supervisord.
COPY bin/supervisord.conf /etc/supervisor/supervisord.conf
ENTRYPOINT [ "supervisord", "-c", "/etc/supervisor/supervisord.conf" ]

# Run everything as standard user/group named "heroes".
RUN groupadd heroes \
 && useradd --create-home --gid heroes heroes
WORKDIR /home/heroes

# Install Heroes of Might & Magic 3 in Wine. 
ADD bin/homm3.reg /home/heroes/bin/homm3.reg
ADD bin/start-h3.sh /home/heroes/bin/start-h3.sh

COPY ["./HoMM3", "/home/heroes/.wine/drive_c/Program Files (x86)/3DO/Heroes III Demo"]
RUN chown -R 1000:0 /home/heroes/
USER heroes

# Heroes Of Might & Magic 3 in a browser running on Docker

This repo will allow you to build a Docker image that contains: 
- X11vnc & NoVnc - to stream an app's window to an HTML page. 
- Pulseaudio & Gstreamer to stream the sound of the app in a separate socket/port. 
- Supervisor to manage all the apps/servers/sockets that needs to launch on boot. 
- Wine - to run the game Heroes of Might & Magic 3 (game files not included). 
- Other libraries and dependencies that are needed to get this to work. 

A live running example: http://yaron.today

Thanks to [@vexingcodes](https://github.com/vexingcodes/dwarf-fortress-docker) for laying the groundworks.

## Usage

You can run `./run.sh` to automatically build the image and run it for you, or alternatively, you can manually build the image using the `Dockerfile`:
To build manually, simply use `docker build -t heroes3 .`. 
After building manually, you'll need to specify a few flags when using `docker run`: 
- `--env DISPLAY_SETTINGS="800x600x24"` - This resolution is fixed to the game. If you change it, the game will break. Other games or apps will probably work with better resolution flexibility. 
- `-p 80:8080 -p 8081:8081` - Point port 80 to the container's port 8080 for the VNC video stream, and port 8081 for the audio stream. 
- `-v savedgames:/home/heroes/.wine/drive_c/Program\ Files\ \(x86\)/3DO/Heroes\ III\ Demo/Games` - If you want persistent savegames files that survive between containers deletion/creation. 

After the container starts, open your browser at `http://localhost` and the game should load up after a few moments. 
You can enlarge the game's screen using the browser's zoom-in function (CTRL and '+' in most browsers). 
The sound will start when you click inside the game's window to focus it, and hit any button on your keyboard. 


A ready-made image is available as well. Simply use `docker pull legojesus/homm3_in_browser`, then run it with the flags mentioned above.

## Details from @vexincodes with minor edits:

At a high level, this repository is simply a Docker image, built using the
`Dockerfile` in this repository. This image is Debian-based, but it should be
straightforward to port to other base images. No special privileges are required
to run the container, and all processes in the container run as the non-root
user named `heroes`. The `run.sh` script automates the building and running of the Docker image.

The container needs to run multiple processes, so we use supervisord as the
init process and it launches all of the background processes. See
`bin/supervisord.conf` for the raw config file. The processes that run are:

* `xvfb` -- The X Virtual FrameBuffer. An in-memory X display server.
* `x11vnc` -- A VNC server that serves the `xvfb` screen on TCP port `5900`.
* `websockify_vnc` -- Serves `x11vnc`, but through a websocket. Also serves the
  files in `/usr/share/novnc` as a webserver. Basically, this process allows the
  `x11vnc` server to be accessible through a browser, using `novnc` as the
  client. This service is exposed on port `8080`.
* `pulseaudio` -- The audio server.
* `audiostream` -- A TCP server listening on port `5901`. This uses
  [ucspi-tcp](https://cr.yp.to/ucspi-tcp.html), a generic TCP client/server
  adapter that can use stdin/stdout for streaming TCP data. When a client
  connects to TCP port `5901`, the `tcpserver` spawns a new process, and the
  stdin/stdout are used for communication between the client and the server. In
  this case, the process that is spawned is a gstreamer pipeline that takes
  audio from the `pulseaudio` server and encodes it as a webm stream.
* `websockify_audio` -- Serves `audiostream`, but through a websocket.
* `heroes3` -- The game Heroes of Might & Magic 3. It draws to the `xvfb` display and
  transmits audio through the `pulseaudio` server. You will need your own copy of the game and dump its files into the HoMM3 folder here for this to work. 

Pulseaudio requires two small configuration files to function properly as a
non-root user. Both `bin/default.pa` and `bin/client.conf` are copied to
`/etc/pulseaudio` within the contianer. The `default.pa` file specifies that by
default the `pulseaudio` server should use the unix socket at
`/tmp/pulseaudio.socket` for communication, and should always have an audio sink
available, even if no audio hardware is detected. Since `/tmp` is writable by
the `heroes` user, this works. The `client.conf` file specifies that by default any
client should use that unix socket as its default server.

Finally, there are the changes required to get `novnc` to connect to and use
this new audio websocket. First, there is a new `webaudio.js` file, written by
GitHub user [no-body-in-particular](https://github.com/no-body-in-particular),
and described in this
[blog post](https://coredump.ws/index.php?dir=code&post=NoVNC_with_audio). This
file is the client-side code that connects to the new websocket and streams the
audio from it. In the `Dockerfile` it can be seen that this file is copied to
`/usr/share/novnc/core/webaudio.js` so it is available among the other `novnc`
core javascript files. Finally, we edit the `vnc_lite.html` file using two sed
commands in the `Dockerfile` (a patch file would probably be more appropriate,
but this works).


```
 && sed -i "/import RFB/a \
      import WebAudio from './core/webaudio.js'" \
    /usr/share/novnc/vnc_lite.html \
 && sed -i "/function connected(e)/a \
      var wa = new WebAudio('ws://localhost:8081/websockify'); \
      document.getElementsByTagName('canvas')[0].addEventListener('keydown', e => { wa.start(); });" \
    /usr/share/novnc/vnc_lite.html
```

The first command edits the file to import the new `webaudio.js` file. The
second command adds new code to the `connected` function that is called when the
VNC session connects. We create a new instance of the `WebAudio` class, and tell
it to start playing audio when a `keydown` event is received by the `canvas`
tag. Presently this is hardcoded to `https://localhost:8081/websockify`. A more
robust implementation would allow the audio URL to be set to different values
depending on the environment.
If you want to be able to hear the audio on other computers that connect to the host's container, change the `https://localhost:8081/websockify` line to the IP of the host (e.g. `https://34.172.110.54:8081`, and open port 8081 in the host's firewall. 

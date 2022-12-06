# Run Heroes Of Might And Magic 3 in your browser (Docker, VNC)
After acomplishing my previous goal of running old dos games in the browser (https://github.com/legojesus/dos-games-in-browser-docker, http://yaron.today), I've been wanting to try more complex setups and see how far can we get with games in browsers. 

Introducing - A fully playable deployment of HoMM3 in a browser! 
This is made possible with: 
- Wine https://www.winehq.org/ - This program allows running Windows apps on other OS/platforms. 
- Vnc4server - A VNC server for linux, much like Remote Desktop. 
- NoVNC - https://novnc.com/info.html - A VNC client that can run in a browser. 
- Websockify - Translates websockets traffic to regular TCP socket traffic.

Basically this deployment runs HoMM3 in a container and streams the game's window via VNC to the browser's VNC client, so you are remotely connected to the container's virtual display and are playing the game inside the container!

## How to deploy and run: 
1. Copy the contents of your local HoMM3 game folder into the HoMM3 folder here.
2. In your CLI, type `docker build -t homm3 .` to build the image. If you don't have the game on your computer or if you'd like to save some time building this image, you can get it from my dockerhub: `docker pull legojesus/homm3_in_browser:latest`.
3. Type `docker run -p 80:8081 --rm homm3` to run the game. Note that the `homm3` bit might change depending on how you named the image when you built it or if you pulled it from dockerhub. Use `docker images` to see your local images and their correct names.
4. Once the game is running, open your browser and type `localhost` in the address bar, then hit Enter. Alternatively, type `127.0.0.1` and hit enter. Either one shouold get you to a webpage with the game running. 

### Additional options: 
 - Sound does not work in the browser. However, you can enable sound in the host machine (the one that is running the docker image) by adding the `--device /dev/snd` flag to the docker run command, e.g. `docker run -p 80:8081 --rm --device /dev/snd homm3`. It won't help you if you're trying to play remotely via a browser but if you are running it locally only, then you'll have sound. 
 - Game saves files are deleted when the container stops. If you'd like to keep the saved games files, use a persistent volume like so: `docker run -p 80:8081 --rm -v savedgames:/root/.wine/drive_c/Program\ Files\ \(x86\)/3DO/Heroes\ III\ Demo/Games homm3`. That'll create a docker volume that will keep the saved games files even if you destroy the container and start a new one, as long as you launch each container with this volume. 


This project was made possible thanks to bmustiata (https://github.com/bmustiata) and Steamvis (https://github.com/Steamvis), who thought about this idea before me and paved the way :)

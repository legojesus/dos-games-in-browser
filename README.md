# Running old dos games in your browser via docker
This repo contains code to build many old dos games in a JavaScript dos emulator, containerized in Docker, to run games in your browser!

### Requirements: 
 - NodeJS (NPM, NPX)
 - Docker (and Docker Compose)

### How to build a single game deployment:
1. Run the bash script "create_game.sh" which will run the `create-dosbox@latest` package. 
2. The package will ask you to enter an old game's name. Type in any old game you want (e.g. "doom") and hit Enter.
3. It will show you a list of possible results (if any). Select the relevant game you want with the arrow keys and hit Enter. 
4. A new folder named "app" will be created with the emulator and the game, afterwwhich the script will perform `npm install` in it. Wait for it to finish.
5. In your terminal, run "docker compose up". It will build a docker image that contains the emulator and the game, and will expose it on port 80.
6. Open your browser and type in your localhost address in the address bar (127.0.0.1) and see if the game loads up. Alternatively, you can type in your machine's internal IP from any other device on your local network and load the game from there (works on phones too!). 
7. (Optional) tag the docker image and push it to dockerhub or your desired image registry and deploy it anywhere (cloud providers, K8s etc). 

For multiple games deployments check out the "website" and "round robin" folders and their READMEs. 


## Additional info
I came up with this project idea because I wanted to be able to deploy and play old games in my browser (via PC or phone) at any time, anywhere, so this project was the perfect fit.
It was extremely educational and a bit challenging at times, improving my NodeJS and Docker skills. I ended up deploying "Doom" containers and other games on a multi-node K8s cluster on Google Cloud Platform, then added load balancers that pointed to my website's domain which was really fun :)

Many thanks and credits to the js-dos project (https://js-dos.com/v7/build/docs/) that made this a lot easier than it should have been! If you like this project, please donate to js-dos to help them maintain this wonderful browser-based emulator!

  
 

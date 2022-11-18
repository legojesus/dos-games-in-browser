# Creating a deployment with multiple games on a simple index.html website:
The goal here is to build a simple website that contains multiple games to choose from, with links to different containers that run each game.

### How to build this:
1. Run the `create-game.sh` script and enter an old game's name when asked. Note that games names should always be lowercase and without spaces otherwise it will most likely break. The script will launch `npx create-dosbox` with your game's name and will use the `expect` linux command to automatically handle the interactive selection menu using the `expect.sh` script. 
2. After the game is installed, the script will create a dockerfile for it, as well as add that game to the `docker-compose.yml` file, and the `nginx.conf` and `index.html` files that are found in the Nginx folder for you. 
3. If you want to add another game, run the script again. If not, then run `docker compose up` to build all the images and deploy the containers. 
4. Open your browser and go to `localhost` or `127.0.0.1` to reach the website and select a game from the list. 
5. Enjoy! 


### How to remove a game from the docker stack and website:
1. Delete the game's folder. 
2. Delete the game's entry from the `docker-compose.yml` file.
3. Delete the game's entry from the `nginx.conf` and `indext.html` files found in the Nginx folder. 
4. Rebuild the stack with `docker compose build`, then deploy it with `docker compose up`.




  
 

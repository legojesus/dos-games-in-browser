#!/bin/bash

echo "Enter an old game's name in lowercase, no spaces (e.g. \"doom\", \"doomii\", \"lionking\", \"princeofpersia\" etc...):"
read game

### Download and install game in dosbox:
expect ./expect_script.exp $game

### Setup npm environment to run the game:
cd $game
npm install
npm audit fix --force


### This will allow to change the default NPM port from 8080 to any port you'd like, but unnecessary when using this in containers with nginx. 
# rm package.json
# cat > package.json << EOF 
# {
#   "name": "js-dos-template",
#   "version": "1.0.0",
#   "description": "js-dos 7.xx template",
#   "scripts": {
#     "start": "PORT=8080 http-server _site",
#     "test": "echo \"Error: no test specified\" && exit 1"
#   },
#   "dependencies": {
#     "http-server": "^14.1.1"
#   }
# }
# EOF

### Create the dockerfile for the container of this new game:
cat > Dockerfile << EOF
FROM node:alpine
RUN mkdir /$game
WORKDIR /$game
COPY ./package.json /$game
RUN npm install
COPY . /$game
CMD npm start run
EXPOSE 8080
EOF

### Add the new game to the docker compose file: 
cd ..
awk -v game="${game}" -i inplace '/services:/ { print; print "    "game":\n        build: ./"game; next }1' docker-compose.yml
echo "            - $game" >> docker-compose.yml

### Add the new game to the nginx config:
cd nginx
awk -v game="${game}" -i inplace '/http {/ { print; print "\n     upstream "game" {\n        server "game":8080;\n     }"; next }1' nginx.conf
awk -v game="${game}" -i inplace '/         server_name localhost;/ { print; print "\n          location /"game" {\n              return 302 /"game"/;\n          }\n\n          location /"game"/ {\n              proxy_pass http://"game"/;\n          }"; next }1' nginx.conf

### Add the new game to the website's HTML:
awk -v game="${game}" -i inplace '/        <h1>Select A Game:<\/h1>/ { print; print "        <div><a href=\"/"game"\"><h2>"game"<\/h2>\<\/a>\<\/div>"; next }1' index.html


### When done, go back to origin and report success:
cd ..
echo
echo
echo
echo
echo "$game was added to the docker stack."
echo "Use 'docker compose up' to deploy the website, or run this script again to add another game."
echo
echo "In case the wrong game was downloaded, remove its folder, remove its entry in nginx.conf, index.html, and docker-compose.yml, then run the script again with a different game name."


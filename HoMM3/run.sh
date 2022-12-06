#!/bin/bash -eux
docker build . --tag heroes3
docker run \
  --detach \
  --env DISPLAY_SETTINGS="800x600x24" \
  --volume savedgames:/home/heroes/.wine/drive_c/Program\ Files\ \(x86\)/3DO/Heroes\ III\ Demo/Games \
  --publish 80:8080 \
  --publish 8081:8081 \
  --rm \
  --name heroes3 \
  heroes3
sleep 3
xdg-open http://localhost

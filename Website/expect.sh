#!/usr/bin/expect -f
set timeout -1

### Start the create-dosbox interactive app to download and install new games, then automatically send it input via this "expect" script:
npx create-dosbox@latest $game

expect "? Enter title of the game to search (e.g. Digger)"
send "$game \n"

expect "? Please select the game from list (Use arrow keys)"
send "\n"
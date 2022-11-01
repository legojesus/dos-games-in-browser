# Creating a round-robin of games in containers
The goal here is to run multiple games containers simultaneously and have a round-robin between them so whenever the browser is refreshed, a different game loads up. 

For this, I tried using 3 different games containers and an nginx container to manage the round robin. 
However, there's a caching problem in which the browser will download the first loaded game file (which is basically a zip file), store it in the browser's cache, and will always load this file from cache when refreshing the page instead of downloading the current game's file in the round-robin. 

The only way to get this to work properly is to clear the cache with each refresh (e.g. CTRL+SHIFT+R in most browsers) or using private browsing/incognito so cache won't be retained. I have yet to find a solution to this problem without building an actual website that will redirect to different paths URLs for every game. 


  
 

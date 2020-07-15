This exercise shows you the steps to add pg_tileserv to your PostGIS implementation. 

First, take a look at the tab in the terminal to the right called "pg_tileserv". You'll see that it's still waiting for an available conneciton on port 7800, the port that pg_tileserv serves data on. That's because we haven't added pg_tileserv to our PostGIS implementation yet. Let's do that now.


```docker run -e DATABASE_URL=postgresql://groot:iam@172.18.0.2/firedata -p 7800:7800 pramsey/pg_tileserv:CI```{{execute}}


Add a mapserver

```docker run -p 8080:8080 timmam/scfire_mapserver```{{execute}}




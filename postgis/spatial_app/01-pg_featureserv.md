
The code block below allows you to click on it to have the code execute in the terminal. Be sure to click on the ```Terminal``` tab before click on the box to make sure the code executes in the correct tab. You also have the option of copying and pasting the code, or typing it yourself in the ```Terminal``` tab.

```docker run -e DATABASE_URL=postgresql://groot:iam@172.18.0.2/firedata -p 9000:9000 pramsey/pg_featureserv:latest```{{execute}}

You'll see that the connection info we provided in the intro (database name: `firedata`, username: `groot`, and password: `iam`) is used in the statement above. 


# Autopilot
### A self configuring nginx built for docker-compose usage.

Build status:

#### Basic usage:

Autopilot is designed for usage with docker-compose. But you can even run the image without a compose file:

`docker run -it -p 8080:8080 -e BALANACE_RULE_WEB='http://localhost:8080->http://your-web-service:3000<example.conf.erb' paradoxxger/autopilot:v-X.X.X`

This runs the container with the following configuration:

Pseudocode: "Balance all incoming traffic on "http://localhost:8080" to "http://your-web-service:3000" with the nginx template "example.conf.erb"."

The container will constantly check if there are more or less dns entries given for "your-web-service", if so it will reload the configuration and restart nginx gracefully.

Please make sure, that the port mapping of the autopilot matches the given incoming traffic port (8080).

Now we are gonna launch a compose file, which has two routes pointing to autopilot. Yep, you can define multiple BALANCE_RULES:

```
version: "3.3"
services:
  auto-pilot:
    build:
      context: .
    image: paradoxxger/autopilot:v0.0.1
    environment:
      - BALANCE_RULE_WEB=http://localhost:8080->http://web<example.conf.erb
      - BALANCE_RULE_WEB2=http://localhost:8081->http://web2<example.conf.erb
      - INTERVAL=60
    networks:
      frontend:
        aliases:
          - auto-pilot
    ports:
      - 8080:8080
      - 8081:8081
  web:
    image: nginx:1.13.7
    networks:
      frontend:
        aliases:
          - web
  web2:
    image: nginx:1.13.7
    networks:
      frontend:
        aliases:
          - web2
networks:
  frontend:
```

We managed to get two sources auto looked up and served via autopilot. With running this compose file you should be able to access
your localhost:8081 and localhost:8080 both displaying the default nginx html page provided by service web and web2.

#### Advanced usage:


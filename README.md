# Skipper
### A self configuring nginx built for docker-compose usage.

[![Build status](https://teamcity.german-rush-company.de/app/rest/builds/buildType:(id:skipper)/statusIcon)](https://teamcity.german-rush-company.de/app/rest/builds/buildType:(id:skipper)/statusIcon)
[![Maintainability](https://api.codeclimate.com/v1/badges/9fd18f74f0da78b7508a/maintainability)](https://codeclimate.com/github/ParadoXxGER/skipper/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/ParadoXxGER/skipper/badge.svg?branch=master)](https://coveralls.io/github/ParadoXxGER/skipper?branch=master)

The Balance rules in detail:

The first part until `->` is the virtual host, nginx should listen on. In this case `localhost:8080`. After `->` you can define your linked service. 
Note: The `web` is a alias in the docker network, means it points to the service  `web`.

`BALANCE_RULE_WEB=URI->URI<CONFIG.FILE`

`BALANCE_RULE_WEB=http://localhost:8080->http://web<example.conf.erb`

#### Basic usage:

```
version: "3.3"
services:
  skipper:
    build:
      context: .
    image: paradoxxger/skipper:v0.0.1
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

If you run this compose, you should be able to access `localhost:8080` and `localhost:8081`.

Now, scale your services and watch skipper creating new config files and gracefully reloading nginx.

`docker-compose scale web=5`


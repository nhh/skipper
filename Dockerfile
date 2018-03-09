FROM nginx:1.13.7

RUN apt-get update

RUN apt-get install ruby -y

RUN gem install rake rubocop spectr

WORKDIR /home/skipper/

COPY . /home/skipper/

RUN rm /etc/nginx/sites-enabled/default

RUN rm /etc/nginx/conf.d/default.conf

RUN spectr test/*

RUN rubocop

RUN chmod +x entrypoint

ENTRYPOINT "./entrypoint"
FROM nginx:1.13.7

RUN apt-get update

RUN apt-get install ruby -y

RUN gem install rake rubocop

WORKDIR /home/skipper/

COPY . /home/skipper/

RUN rubocop

RUN chmod +x ./entrypoint.sh

ENTRYPOINT "./entrypoint.sh"
FROM nginx:1.13.7

RUN apt-get update

RUN apt-get install ruby -y

COPY Gemfile /home/skipper/Gemfile

COPY Gemfile.lock /home/skipper/Gemfile.lock

RUN bundle install

COPY . /home/skipper/

WORKDIR /home/skipper/

RUN rubocop

RUN chmod +x ./entrypoint.sh

ENTRYPOINT "./entrypoint.sh"
FROM ruby:2.2.4

EXPOSE 5000

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -yq     \
  redis-server && \
  apt-get clean

COPY . /spotifried
WORKDIR /spotifried
RUN bundle install
RUN gem install foreman

CMD ["bash", "start.sh"]
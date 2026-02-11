FROM ruby:3.3.4

RUN apt-get update -qq && apt-get install -y \
    postgresql-client \
    nodejs \
    npm \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN gem install bundler
EXPOSE 3000

CMD ["bash", "-c", "bundle check || bundle install && rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0"]

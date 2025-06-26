FROM ruby:3.1

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install

COPY . .

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

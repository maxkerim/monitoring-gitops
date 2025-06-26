FROM ruby:3.2.3-slim

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    libsqlite3-dev \
    git \
    pkg-config \
    libpq-dev \
    nodejs \
    sqlite3 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /rails

RUN gem install bundler:2.5.23

COPY Gemfile Gemfile.lock ./

RUN bundle _2.5.23_ install

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]


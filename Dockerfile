FROM ruby:2.6.1
ENV DIR="/jq22_check_in" GEM_HOME="/usr/local/bundle" PATH="$GEM_HOME/bin:$PATH"
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev && apt-get install -y cron vim wget
RUN mkdir $DIR
WORKDIR $DIR
COPY Gemfile* $DIR/
RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ \
    && gem install bundler && bundle install
COPY . $DIR
RUN bundle exec whenever --update-crontab
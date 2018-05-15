FROM ruby:2.2.3
ENV DIR="/jq22_check_in" PHANTOM_JS="phantomjs-2.1.1-linux-x86_64" \
    MydlCookie="xx" Myinfo="xx" cokbut="xx" CityCookie="xx" ASP_NET_SessionId="xx"
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev && apt-get install -y cron vim wget \
    && apt-get install -y libfreetype6 libfreetype6-dev \
    && apt-get install -y libfontconfig1 libfontconfig1-dev
RUN mkdir $DIR
WORKDIR $DIR
COPY Gemfile* $DIR/
RUN gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/ \
    && gem install bundler -v '1.16.1' \
    && gem install ffi -v '1.9.23' \
    && bundle install
COPY . $DIR
RUN wget -P $DIR https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
RUN tar xvjf $DIR/$PHANTOM_JS.tar.bz2
RUN mv $DIR/$PHANTOM_JS /usr/local/share
RUN ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin
RUN ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/bin/phantomjs
RUN bundle exec whenever --update-crontab

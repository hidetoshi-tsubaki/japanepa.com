FROM ruby:2.5.1
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN mkdir /myapp
ENV APP_ROOT /myapp
WORKDIR $APP_ROOT
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
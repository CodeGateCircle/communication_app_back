FROM ruby:3.1.2

RUN apt update -qq && apt install -y postgresql-client
RUN mkdir /communication_app_back
WORKDIR /communication_app_back
COPY Gemfile /communication_app_back/Gemfile
COPY Gemfile.lock /communication_app_back/Gemfile.lock
RUN bundle install
COPY . /communication_app_back

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
# Building stage
#===============
FROM ruby:2.6.3

ARG precompileassets

# Needed for Yarn
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev curl software-properties-common && \
  curl -sL https://deb.nodesource.com/setup_12.x |  bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && \
  apt-get install -y nodejs yarn && \
  apt-get remove -y --purge software-properties-common &&\
  rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app

RUN gem install bundler

COPY package.json *yarn* ./
RUN yarn install --check-files

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle config --global frozen 1 \
  && bundle install \
  && rm -rf /usr/local/bundle/bundler/gems/*/.git \
    /usr/local/bundle/cache/

# Install chromedriver
COPY bin/chromedriver_install_docker bin/chromedriver_install_docker
RUN bin/chromedriver_install_docker

COPY . /app
RUN bundle exec rake i18n:js:export && ls /app/public/javascripts/translations.js

RUN bin/potential_asset_precompile.sh $precompileassets

# Run stage
#==========
# We could do multi stage builds by adding this

#<ADD>
#FROM ruby:2.6.3

#RUN mkdir -p /app
#WORKDIR /app

#COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
#COPY --from=builder /app/ /app/
# </ADD>

EXPOSE 3000

ENTRYPOINT ["/app/lib/docker-entrypoint.sh"]
CMD ["rails","server","-b","0.0.0.0","-p","3000"]


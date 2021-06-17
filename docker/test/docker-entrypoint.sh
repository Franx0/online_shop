#!/bin/bash

if [ -f $APP_HOME/tmp/pids/server.pid ]; then
 rm $APP_HOME/tmp/pids/server.pid
fi

command=$@

# Checks gems installation
bash -lc "bundle check || bundle install --no-binstubs"
bash -lc "bundle exec rake db:create RAILS_ENV=test"
bash -lc "bundle exec rake db:migrate RAILS_ENV=test"
bash -lc "bundle exec ${command}"

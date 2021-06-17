#!/bin/bash

if [ -f $APP_HOME/tmp/pids/server.pid ]; then
 rm $APP_HOME/tmp/pids/server.pid
fi

command=$@

# Checks gems installation
bash -lc "bundle check || bundle install --no-binstubs"

# Checks db migrations status
if [[ command =~ "db:migrate" || command =~ "db:setup" ]]; then
	bash -lc "bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup"
else
  {
    bash -lc "bundle exec rake db:migrate 2>/dev/null"
  } || {
    bash -lc "bundle exec rake db:create"
    bash -lc "bundle exec rake db:migrate 2>/dev/null"
  }
fi

# Checks yarn package installation
yarn_status=$(bash -lc "yarn check --modules-folder '/opt/shop/node_modules'")

if [[ $yarn_status =~ 'success' ]]; then
  bash -lc "echo 'Up to date with yarn'"
else
  bash -lc "yarn cache clean && yarn install --check-files"
fi

bash -lc "bundle exec ${command}"

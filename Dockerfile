FROM ruby:3.0.1

# Install Node && Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get install -y nodejs
RUN apt-get update && apt-get install -y yarn

# Set docker user var
ENV DOCKER_USER root
# Set the app directory var
ENV APP_HOME /opt/shop
ARG ENVIRONMENT=development
ARG PROJECT_PATH=.

# Set entrypoint file
ADD $PROJECT_PATH/docker/$ENVIRONMENT/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# Install bundler
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=2 \
  BUNDLE_PATH=/vendor/bundle

# Copy app on path
ADD $PROJECT_PATH $APP_HOME

WORKDIR $APP_HOME

USER $DOCKER_USER

##################### INSTALLATION ENDS #####################
EXPOSE 3000
EXPOSE 80
EXPOSE 443

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG APP_HOME=/opt/unlight
ARG RUBY_VERSION=2.7.2

# Pre-compile Gems
FROM ruby:${RUBY_VERSION}-alpine AS gem

RUN apk --update \
        add --no-cache \
        build-base=~0.5 \
        ca-certificates=~20191127 \
        zlib-dev=~1.2.11 \
        libressl-dev=~3.1.2

# Setup Application
ARG APP_HOME
ENV APP_HOME=${APP_HOME}

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/
RUN gem install bundler:2.1.4 \
    && bundle config --local deployment 'true' \
    && bundle config --local frozen 'true' \
    && bundle config --local no-cache 'true' \
    && bundle config --local system 'true' \
    && bundle config --local without 'build development test' \
    && bundle install -j "$(getconf _NPROCESSORS_ONLN)" \
    && find /${APP_HOME}/vendor/bundle -type f -name '*.c' -delete \
    && find /${APP_HOME}/vendor/bundle -type f -name '*.o' -delete \
    && find /usr/local/bundle -type f -name '*.c' -delete \
    && find /usr/local/bundle -type f -name '*.o' -delete \
    && rm -rf /usr/local/bundle/cache/*.gem

# Server
FROM ruby:${RUBY_VERSION}-alpine

RUN apk --update \
        add --no-cache \
        ca-certificates=~20191127 \
        zlib=~1.2.11 \
        libressl=~3.1.2

ARG APP_HOME
ENV APP_HOME=${APP_HOME}

RUN adduser -h ${APP_HOME} -D -s /bin/nologin app app

# Setup Application
RUN mkdir -p $APP_HOME

COPY --from=gem /usr/local/bundle/config /usr/local/bundle/config
COPY --from=gem /usr/local/bundle /usr/local/bundle
COPY --chown=app:app --from=gem /${APP_HOME}/vendor/bundle /${APP_HOME}/vendor/bundle

# Add Source Files
COPY --chown=app:app . $APP_HOME

ENV PATH $APP_HOME/bin:$PATH

USER app
WORKDIR $APP_HOME

EXPOSE 3000

ENTRYPOINT ["entrypoint"]

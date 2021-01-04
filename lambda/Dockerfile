ARG RUBY_VERSION=2.7

FROM lambci/lambda:build-ruby${RUBY_VERSION}

ARG FUNCTION_ROOT=/var/task
ENV FUNCTION_ROOT $FUNCTION_ROOT

RUN mkdir -p $FUNCTION_ROOT && \
    mkdir -p $FUNCTION_ROOT/lib

WORKDIR $FUNCTION_ROOT

COPY Gemfile* $FUNCTION_ROOT/

RUN bundle config --local deployment 'true' \
    && bundle config --local frozen 'true' \
    && bundle config --local no-cache 'true' \
    && bundle config --local system 'true' \
    && bundle config --local without 'build development test web' \
    && bundle config --local path 'vendor/bundle' \
    && bundle install -j "$(getconf _NPROCESSORS_ONLN)" \
    && find /${FUNCTION_ROOT}/vendor/bundle -type f -name '*.gem' -delete \
    && find /${FUNCTION_ROOT}/vendor/bundle -type f -name '*.c' -delete \
    && find /${FUNCTION_ROOT}/vendor/bundle -type f -name '*.o' -delete \
    && find /${FUNCTION_ROOT}/vendor/bundle -type d -name 'ext' -exec rm -rf {} +

COPY . $FUNCTION_ROOT/

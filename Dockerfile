ARG RUBY_VERSION=3.4.1

FROM ruby:$RUBY_VERSION AS development
ENV TZ=UTC
ENV HOME=/ror
RUN mkdir /ror
WORKDIR /ror
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives
COPY Gemfile Gemfile.lock /ror/
RUN curl -fsSL https://bun.sh/install | bash
COPY package.json bun.lock /ror/
RUN bundle install

#FROM ruby:$RUBY_VERSION-bookworm AS production
#ENV TZ=UTC
#ENV RAILS_ENV="development" \
#    BUNDLE_DEPLOYMENT="1" \
#    BUNDLE_PATH="/usr/local/bundle"
#ARG DOCKER_GID=2222
#ARG DOCKER_GROUP=company
#ARG DOCKER_UID=4444
#ARG DOCKER_USER=member
#RUN groupadd -g ${DOCKER_GID} ${DOCKER_GROUP}
#RUN bundle install && \
#    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
#    bundle exec bootsnap precompile --gemfile
#RUN useradd ${DOCKER_USER} -u ${DOCKER_UID} -g ${DOCKER_GROUP}
#RUN chown -R ${DOCKER_USER}:${DOCKER_GROUP} db log storage tmp
#ADD ./ /ror
#USER ${DOCKER_USER}

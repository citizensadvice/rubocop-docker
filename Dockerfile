FROM ruby:2.7-alpine as build

ENV BUNDLER_VERSION 2.1.4

RUN apk add --no-cache --update build-base git

ADD Gemfile* /rubocop/
WORKDIR /rubocop

ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=6 \
    BUNDLE_RETRY=3

RUN gem update --system && gem install bundler && bundle install && gem cleanup

FROM ruby:2.7-alpine as rubocop

WORKDIR /rubocop
COPY --from=build /usr/local /usr/local
ADD ./ /rubocop

CMD bundle exec rubocop /app

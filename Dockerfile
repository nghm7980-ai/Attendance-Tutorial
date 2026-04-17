# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.0.6
FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /myapp

ENV RAILS_ENV="development" \
  BUNDLE_PATH="/usr/local/bundle"

# --- 修正箇所：ここから ---
# 実行環境（Final stage）でもGemのビルドができるように、
# 必要なパッケージを Final stage のベースとなるここに追加します
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    default-libmysqlclient-dev \
    git \
    libvips \
    pkg-config \
    curl \
    default-mysql-client \
    libffi-dev \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives
# --- 修正箇所：ここまで ---

FROM base as build

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
  rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
  bundle exec bootsnap precompile --gemfile

COPY . .
RUN bundle exec bootsnap precompile app/ lib/
# 開発環境なので assets:precompile はコメントアウトしても良いですが、一旦そのままにします
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage
FROM base

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /myapp /myapp

RUN gem install bundler -v 2.5.23
RUN useradd rails --create-home --shell /bin/bash && \
  chown -R rails:rails db log storage tmp

# 開発中は権限エラーを防ぐため、一旦 root ユーザーで作業するように設定します
USER root

ENTRYPOINT ["/myapp/entrypoint.sh"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
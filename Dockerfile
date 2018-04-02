FROM elixir:1.5-alpine

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/opt/app/ TERM=xterm

RUN apk update && apk upgrade
RUN apk add git

# Install Hex+Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /opt/app
ENV MIX_ENV=prod REPLACE_OS_VARS=true

# Cache elixir deps
COPY mix.exs mix.lock ./
RUN mix deps.get
COPY config ./config
RUN mix deps.compile

COPY . .
RUN mix release --env=prod

FROM elixir:1.5-alpine

ENV DEBIAN_FRONTEND=noninteractive
ENV MIX_ENV=prod REPLACE_OS_VARS=true

RUN apk update && apk upgrade
RUN apk add bash

WORKDIR /app
COPY --from=0 /opt/app/_build/prod/rel/phx_channels_backend_umbrella .

ENTRYPOINT ["bin/phx_channels_backend_umbrella"]

#FROM elixir:1.14-alpine
#FROM elixir:1.11.4-alpine
#FROM elixir:1.10.4-alpine
#FROM elixir:1.14-otp-25-alpine
#FROM elixir:1.16.3-otp-26-alpine
FROM elixir:1.16.3-otp-26

#MAINTAINER Peter de Croos <cultofmetatron@aumlogic.com>

### add these so that reloading works
#RUN apk add inotify-tools

ENV APP_HOME /app

RUN apt update
RUN apt install -y zsh curl wget git inotify-tools

#RUN apk add zsh curl wget git
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)"
### Install rebar and hex
### Install OS packages for nodejs, npm, git etc.
RUN mix local.rebar --force
RUN mix local.hex --force
RUN mix archive.install --force hex phx_new
###RUN apk add --no-cache --update nodejs npm bash openssl git make gcc g++
RUN mix local.rebar --force

#RUN set -x \
#    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
#    && apk upgrade \
#    && apk --no-cache add alpine-sdk bash libstdc++ libc6-compat
 
#RUN git clone --recursive https://github.com/cdr/code-server.git
#RUN cd code-server
#RUN yarn global add code-server

WORKDIR ${APP_HOME}
#RUN mix deps.get

# Mount $APP_HOME directory as a volume
VOLUME  $APP_HOME

EXPOSE 4000 4001 5435 5432

CMD ["mix", "phx.server"]
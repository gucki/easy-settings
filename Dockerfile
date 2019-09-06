FROM ruby:2.6-stretch

RUN groupadd --gid 1000 web && useradd --create-home --uid 1000 --gid 1000 --shell /bin/bash web

WORKDIR /home/web/app

USER web

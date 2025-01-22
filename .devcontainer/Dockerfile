FROM ruby:3.4-alpine AS base

RUN apk upgrade && apk -U add \
  bash \
  build-base \
  git

RUN addgroup --gid 1000 vscode
RUN adduser --uid 1000 vscode --ingroup vscode --disabled-password
RUN chown -R vscode:vscode /usr/local/bundle

USER vscode

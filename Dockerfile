FROM ruby:2.7.7

ENV APP_HOME /app
RUN mkdir ${APP_HOME}
WORKDIR ${APP_HOME}
COPY . ${APP_HOME}
ENV BUNDLE_PATH /bundle

RUN apt-get update
RUN apt install nodejs postgresql -y
RUN bundle install

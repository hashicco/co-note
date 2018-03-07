FROM ruby:2.5.0-alpine

ARG FILES=.
ARG APP_ROOT=/var/rails 
ENV BUILD_PACKAGES="build-base bash openssh-client git" \
    DEV_PACKAGES="curl-dev ruby-dev zlib-dev libxml2-dev libxslt-dev yaml yaml-dev mysql-dev nodejs tzdata"

EXPOSE  3000

RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add --update --no-cache\
        $BUILD_PACKAGES \
        $DEV_PACKAGES \
    && gem install bundler --no-ri --no-rdoc -- --use-system-libraries \
    && bundle config --global build.nokogiri --use-system-libraries \
    && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && echo

COPY ${FILES}/server.sh /usr/local/bin/server.sh
COPY ./rails ${APP_ROOT}
WORKDIR $APP_ROOT

RUN set -ex \
    && chmod +x /usr/local/bin/server.sh \
    && bundle install \
    && echo
    
CMD ["server.sh"]

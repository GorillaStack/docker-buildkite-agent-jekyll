FROM gorillastack/buildkite-agent-aws
MAINTAINER Elliott Spira <elliott@gorillastack.com>

#############################################################################
# Install Jekyll
# Based on https://github.com/inadarei/alpine-jekyll/blob/master/Dockerfile (thank you)
##############################################################################

RUN apk upgrade --update \
 && apk add libatomic readline readline-dev libxml2 libxml2-dev \
        ncurses-terminfo-base ncurses-terminfo \
        libxslt libxslt-dev zlib-dev zlib \
        ruby ruby-dev yaml yaml-dev \
        libffi-dev build-base git nodejs \
        ruby-io-console ruby-irb ruby-json ruby-rake \
 && gem install --no-document redcarpet kramdown maruku rdiscount RedCloth liquid pygments.rb \
 && gem install --no-document sass safe_yaml \
 && gem install --no-document jekyll -v 3 \
 && rm -rf /root/src /tmp/* /usr/share/man /var/cache/apk/* \
 && apk del build-base zlib-dev ruby-dev readline-dev \
            yaml-dev libffi-dev libxml2-dev \
 && apk search --update

##############################################################################
# ~ fin ~
##############################################################################

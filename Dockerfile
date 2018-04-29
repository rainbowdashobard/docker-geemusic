FROM ubuntu:14.04.4
MAINTAINER Spencer Julian <hellothere@spencerjulian.com>

RUN echo deb http://deb.theforeman.org/ trusty 1.17>>/etc/apt/sources.list

RUN wget -q https://deb.theforeman.org/pubkey.gpg -O- | apt-key add - \
 && apk update \
 && apk upgrade \
 && apk add --update curl wget bash ruby ruby-bundler python3 python3-dev py3-pip dumb-init musl linux-headers build-base libffi-dev openssl-dev ruby-rdoc ruby-irb\
 && rm -rf /var/cache/apk/* \
 && mkdir /geemusic \
 && apt-get install foreman foreman-sqlite3 foreman-libvirt \
 && cp /usr/share/foreman/config/database.yml.example /etc/foreman/database.yml \
 && foreman-rake db:migrate \
 && foreman-rake db:seed \

COPY . /geemusic
WORKDIR /geemusic

RUN pip3 install -r requirements.txt \
 && gem install foreman

EXPOSE 5000

# Make sure to run with the GOOGLE_EMAIL, GOOGLE_PASSWORD, and APP_URL environment vars!
ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["foreman", "start"]

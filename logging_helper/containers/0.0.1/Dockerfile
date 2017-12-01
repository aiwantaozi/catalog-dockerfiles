FROM fluent/fluentd:stable-debian-onbuild
LABEL maintainer="michelia@rancher.com"

USER root
COPY .apt.sources.list /etc/apt/sources.list

COPY entry.sh /usr/bin/
COPY conf.d /etc/confd/conf.d
COPY templates /etc/confd/templates

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev curl jq" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \

 # cutomize following instruction as you wish
 && sudo -u fluent gem install \
        fluent-plugin-elasticsearch \
        fluent-plugin-systemd \
        systemd-journal \

 && sudo -u fluent gem sources --clear-all \
 && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
           /home/fluent/.gem/ruby/2.3.0/cache/*.gem

RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 -o /usr/local/bin/confd && \
  chmod +x /usr/local/bin/confd

ENTRYPOINT ["/usr/bin/entry.sh"]

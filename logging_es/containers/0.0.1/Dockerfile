FROM fluent/fluentd:v0.14-debian-onbuild

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
COPY entry.sh /usr/bin/
COPY conf.d /etc/confd/conf.d
COPY templates /etc/confd/templates

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            curl \
            jq \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/*

 RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 -o /usr/local/bin/confd \
 && chmod +x /usr/local/bin/confd

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && sudo gem install \
        fluent-plugin-elasticsearch \
        fluent-plugin-dedot_filter \
        fluent-plugin-docker_metadata_filter \
	fluent-plugin-systemd \
	systemd-journal \
 && sudo gem sources --clear-all \
 && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
           /home/fluent/.gem/ruby/2.3.0/cache/*.gem

ENTRYPOINT ["/usr/bin/entry.sh"]
CMD ["fluentd", "-c", "/fluentd/etc/fluent-generated.conf"]

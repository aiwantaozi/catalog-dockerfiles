#!/bin/sh

set -e

for i in $(curl -s --unix /var/run/docker.sock http://localhost/info | jq -r .DockerRootDir) /var/lib/docker /run /var/run; do
    for m in $(tac /proc/mounts | awk '{print $2}' | grep ^${i}/); do
        if [ "$m" != "/run/log/journal" ]&&[ "$m" != "/run/docker.sock" ]; then
            umount $m || true
        fi
    done
done

confd --backend rancher --prefix /2016-07-29 &

# Wait for confd to create initial config files
while [ ! -f /fluentd/etc/fluent-generated.conf ]; do
  sleep 1
done

exec "$@" 

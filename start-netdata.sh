#! /bin/bash

docker run -d --name=netdata \
  -p 19999:19999 \
  -e PGID=111 \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /srv/netdata:/var/cache/netdata \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  netdata/netdata

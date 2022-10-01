#!/bin/bash
set -e

USERNAME=${USERNAME:-user}
PASSWORD=${PASSWORD:-pass}
VOLUME=${VOLUME:-/data}
CONFIG=/opt/rsyncd

setup_rsyncd(){
	echo "$USERNAME:$PASSWORD" > /opt/rsyncd/rsyncd.secrets
    chmod 0400 /opt/rsyncd/rsyncd.secrets
	[ -f /opt/rsyncd/rsyncd.conf ] || cat > /opt/rsyncd/rsyncd.conf <<EOF
pid file = /opt/rsyncd/rsyncd.pid
log file = /dev/stdout
timeout = 300
max connections = 1
port = 8873

[volume]
	uid = root
	gid = root
	read only = false
	path = ${VOLUME}
	comment = ${VOLUME} directory
	auth users = ${USERNAME}
	secrets file = /opt/rsyncd/rsyncd.secrets
EOF
}

mkdir -p $VOLUME
setup_rsyncd
exec /usr/bin/rsync --no-detach --daemon --config /opt/rsyncd/rsyncd.conf "$@"

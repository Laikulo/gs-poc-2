#!/usr/bin/env bash


die() {
	echo "${1:-Fatal Error}" >&2
	exit 1
}

apt-get install $(cat package-list)

set -e -x

[[ -d /srv/www-outside ]] || mkdir /srv/www-outside

install confs/Caddyfile /etc/caddy/Caddyfile
systemctl reload caddy

install confs/dnsmasq-ghostship.conf /etc/dnsmasq.d/dnsmasq-ghostship.conf
systemctl restart dnsmasq

if [[ ! -d /srv/www-outside/mainsail ]]; then
	unzip assets/mainsail-path.zip -d /srv/www-outside/mainsail
fi

if [[ ! -d /srv/www-outside/fluidd ]]; then
	unzip assets/fluidd-path.zip -d /srv/www-outside/fluidd
fi

[[ -d /srv/tftp ]] || mkdir /srv/tftp

rsync -r --delete ./tftproots/ /srv/tftp/

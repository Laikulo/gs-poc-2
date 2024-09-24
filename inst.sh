#!/usr/bin/env bash


die() {
	echo "${1:-Fatal Error}" >&2
	exit 1
}

apt-get install $(cat package-list)

set -e -x

[[ -d /srv/www-outside/htdocs ]] || mkdir -p /srv/www-outside/htdocs
[[ -d /srv/www-outside/templates ]] || mkdir -p /srv/www-outside/templates

cp confs/caddy-fluidd-config.json.tpl /srv/www-outside/templates/fluidd-config.json
cp confs/caddy-mainsail-config.json.tpl /srv/www-outside/templates/mainsail-config.json
cp confs/pgcode.html.tpl /srv/www-outside/templates/pgcode.html

install confs/Caddyfile /etc/caddy/Caddyfile
systemctl reload caddy

install confs/dnsmasq-ghostship.conf /etc/dnsmasq.d/dnsmasq-ghostship.conf
systemctl restart dnsmasq

if [[ ! -d /srv/www-outside/htdocs/mainsail ]]; then
	unzip assets/mainsail-path.zip -d /srv/www-outside/htdocs/mainsail
fi

if [[ ! -d /srv/www-outside/htdocs/fluidd ]]; then
	unzip assets/fluidd-path.zip -d /srv/www-outside/htdocs/fluidd
fi

[[ -d /srv/tftp ]] || mkdir /srv/tftp

#rsync -r --delete ./tftproots/ /srv/tftp/

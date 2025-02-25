
AUTHENTIK_POSTGRESQL__USER ?= ak1
export AUTHENTIK_POSTGRESQL__USER
AUTHENTIK_POSTGRESQL__PASSWORD ?= abdhjoisjijjwnw3233
export AUTHENTIK_POSTGRESQL__PASSWORD

%.yml:
	docker compose -f $*.yml up

authentik:
	docker compose -f authentik.yml up

certbot:
	stat ./secrets/b5nine.com-fullchain.pem \
		|| certbot certonly --dns-cloudflare --dns-cloudflare-credentials ./secrets/cloudflare.ini -d '*.b5nine.com' \
		&& ln -s /etc/letsencrypt/live/b5nine.com/fullchain.pem ./secrets/b5nine.com-fullchain.pem \
		&& ln -s /etc/letsencrypt/live/b5nine.com/privkey.pem ./secrets/b5nine.com-privkey.pem
	certbot certificates

freeipa: # TODO
	docker run --name ipa -ti -h ipa.example.test -v ./data/ipa:/data:z freeipa/freeipa-server:almalinux-9

preqs:
	zypper in docker docker-compose python3-certbot-dns-cloudflare nnn
	systemctl enable --now docker
	## MAYDO: userns-remap, https://hub.docker.com/r/freeipa/freeipa-server/
	## setsebool -P container_manage_cgroup 1
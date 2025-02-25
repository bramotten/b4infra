
AUTHENTIK_POSTGRESQL__USER 		?= ak1
AUTHENTIK_POSTGRESQL__PASSWORD 	?= abdhjoisjijjwnw3233
export AUTHENTIK_POSTGRESQL__USER
export AUTHENTIK_POSTGRESQL__PASSWORD

up-%:
	docker compose -f $*.yml up
	docker compose -f $*.yml down

certbot-b5nine.com:
	stat ./secrets/b5nine.com-fullchain.pem \
		|| certbot certonly --dns-cloudflare --dns-cloudflare-credentials ./secrets/cloudflare.ini -d '*.b5nine.com' \
		&& ln -s /etc/letsencrypt/live/b5nine.com/fullchain.pem ./secrets/b5nine.com-fullchain.pem \
		&& ln -s /etc/letsencrypt/live/b5nine.com/privkey.pem ./secrets/b5nine.com-privkey.pem
	certbot certificates

preqs:
	zypper in docker docker-compose python3-certbot-dns-cloudflare nnn
	systemctl enable --now docker
	## MAYDO: userns-remap, https://hub.docker.com/r/freeipa/freeipa-server/
	## setsebool -P container_manage_cgroup 1
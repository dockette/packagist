# Packagist

Well-prepeared Packagist docker image(s). Run you own composer packagist portal in Docker.

-----

[![Docker Stars](https://img.shields.io/docker/stars/dockette/packagist.svg?style=flat)](https://hub.docker.com/r/dockette/packagist/)
[![Docker Pulls](https://img.shields.io/docker/pulls/dockette/packagist.svg?style=flat)](https://hub.docker.com/r/dockette/packagist/)

## Discussion / Help

[![Join the chat](https://img.shields.io/gitter/room/dockette/dockette.svg?style=flat-square)](https://gitter.im/dockette/dockette?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Architecture

This whole project concists of 4 containers and 1 data-only container.

- Packagist (nginx,php)
- Redis (memory story)
- Solr (search engine)
- Busybox (data-only)

## Installation

Download prepared `docker-compose.yml` to your pc / server.

### Solr

Create `data/solr` folder a chown file permission to ID `8983`.

```
chown 8983:8983 data/solr
```

### Packagist

You should change prepared configuration.

- `PACKAGIST_DATABASE_USER` (packagist)
- `PACKAGIST_DATABASE_PASSWORD` (packagist)

## Usage

Type `docker-compose up -d` and see the magic.


### MySQL

Execute all packagist MySQL migrations.

```
docker-compose exec packagist /srv/app/console doctrine:schema:create
```

### Packagist

Please create your account and add some composer package.

```
docker-compose exec packagist /srv/app/console packagist:update --no-debug --env=prod --force
docker-compose exec packagist /srv/app/console packagist:dump --no-debug --env=prod --force
```

Attribute `force` is needed for the first-run.

### Solr

Index your first composer package. 

```
docker-compose exec packagist /srv/app/console packagist:index --no-debug --env=prod --force
```

## Cron

Cron is configured per 1 minute. You can change by replacing these files:

- /etc/crontabs/root
- /etc/periodic/1min/packagist

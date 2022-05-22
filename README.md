# Packagist

Well-prepeared Packagist docker image(s). Run you own composer packagist portal in Docker.

-----

[![Docker Stars](https://img.shields.io/docker/stars/dockette/packagist.svg?style=flat)](https://hub.docker.com/r/dockette/packagist/)
[![Docker Pulls](https://img.shields.io/docker/pulls/dockette/packagist.svg?style=flat)](https://hub.docker.com/r/dockette/packagist/)

## Discussion / Help

[![Join the chat](https://img.shields.io/gitter/room/dockette/dockette.svg?style=flat-square)](https://gitter.im/dockette/dockette?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Architecture

This whole project consists of 4 containers and 1 data-only container.

- Packagist (nginx,php)
- MariaDB (database)
- Redis (memory storage)
- Solr (search engine)

This version contains the latest version of Packagist [fork with a search engine for Algolia and Solr](https://github.com/ModelTech/packagist). By default it is set to Solr

## Installation

Download prepared `docker-compose.yml` to your pc / server.

### Solr

Create `data/solr` folder a chown file permission to ID `8983`.

```
chown 8983:8983 data/solr
```

### Packagist

You should change prepared configuration.

- `APP_HOSTNAME` (packagist.local:8000)
- `APP_SCHEME` (http)
- `ALGOLIA_HOST` (packagist.local:8000/search2) # "/search2" - route for SOLR search engine, emulate Algolia api 
- `PACKAGIST_DATABASE_DSN` (mysqli://packagist:packagist@mysql:3306/packagist?serverVersion=10.2.12)

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
docker-compose exec --user www-data packagist /srv/app/console packagist:update --no-debug --env=prod --force
docker-compose exec --user www-data packagist /srv/app/console packagist:dump --no-debug --env=prod --force
```

Attribute `force` is needed for the first-run.

#### SSH

You can provide your own SSH keys, just uncommenting lines in docker-compose.yml.

```
volumes:
  - ./config/ssh/config:/var/www/.ssh/config
  - ./config/ssh/id_ed25519:/var/www/.ssh/id_ed25519
  - ./config/ssh/id_ed25519.pub:/var/www/.ssh/id_ed25519.pub
  - ./config/ssh/known_hosts:/var/www/.ssh/known_hosts
```

Don't forget to change owernership to Alpine's user www-data (82:82).

```
sudo chown -R 82:82 config id_rsa id_rsa.pub known_hosts
```

### Solr

Index your first composer package.

```
docker-compose exec packagist /srv/app/console packagist:index --no-debug --env=prod --force
```

## Cron

Cron is configured per 1 minute. You can change by replacing these files:

- /etc/crontabs/root
- /etc/periodic/1min/packagist

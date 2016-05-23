# Packagist

[![Docker Stars](https://img.shields.io/docker/stars/dockette/packagist.svg?style=flat)](https://hub.docker.com/r/dockette/packagist/)
[![Docker Pulls](https://img.shields.io/docker/pulls/dockette/packagist.svg?style=flat)](https://hub.docker.com/r/dockette/packagist/)

Run you own composer packagist portal in Docker.

## Containers

- Nginx
- PHP
- Redis
- Solr

## SSH-keys

This repository contains dummy pregenerated 2048b RSA key, just for testing.

## Usage

For more information follow `docker-compose.yml` file.

### Nginx 

Based on my Nginx image.

There are 2 nginx sites.

- **Stable** version on port 8000.
- **Dev** version on port 9000.

### PHP

Based on my PHP7 + FPM image.

Git is already preinstalled. And you need your own SSH keys.

```sh
ssh-keygen -t rsa -b 4096 -c 'Packagist'
```

### Solr

Based on my SOLR image.

You have to manually create collection via script `create-collection.sh`.

```sh
docker exec -it packagist_solr_1 sh create-collection.sh
```

## Data

By default, `docker-compose.yml` reffer nginx / solr / redis data to `./data`. 
But you can change it if you want to.

## Application

By default, you should have packagist application in `./app` folder.
 
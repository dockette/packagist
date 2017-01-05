# Packagist

Well-prepeared Packagist docker image(s). Run you own composer packagist portal in Docker.

-----

[![Docker Stars](https://img.shields.io/docker/stars/dockette/packagist.svg?style=flat)](https://hub.docker.com/r/dockette/packagist/)
[![Docker Pulls](https://img.shields.io/docker/pulls/dockette/packagist.svg?style=flat)](https://hub.docker.com/r/dockette/packagist/)

## Discussion / Help

[![Join the chat](https://img.shields.io/gitter/room/dockette/dockette.svg?style=flat-square)](https://gitter.im/contributte/contributte?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Architecture

This whole project concists of 4 containers and 1 data-only container.

- Nginx (proxy/webserver)
- PHP (backend)
- Redis (memory story)
- Solr (search engine)
- Busybox (data-only)

## 

@todo
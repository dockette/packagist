DOCKER_IMAGE=dockette/packagist

build: docker-build-packagist docker-build-solr

test: test-compose test-packagist test-solr

run:
	docker compose up

_docker-build-%: APP=$*
_docker-build-%:
	docker build \
		--pull \
		-t ${DOCKER_IMAGE}:${APP} \
		./${APP}

docker-build-packagist: _docker-build-packagist
docker-build-solr: _docker-build-solr

test-compose:
	docker compose config

test-packagist:
	docker run --rm ${DOCKER_IMAGE}:packagist sh -lc 'php -v && composer --version && test -f /srv/app/config/parameters.yml.dist'

test-solr:
	docker run --rm ${DOCKER_IMAGE}:solr sh -lc 'java -version && test -f /opt/solr/server/solr/configsets/data_driven_schema_configs/conf/managed-schema'

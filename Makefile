DOCKER_IMAGE=dockette/packagist

_docker-build-%: APP=$*
_docker-build-%:
	docker build \
		--pull \
		-t ${DOCKER_IMAGE}:${APP} \
		./${APP}

docker-build-packagist: _docker-build-packagist
docker-build-solr: _docker-build-solr


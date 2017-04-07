FROM solr:6.3-alpine

MAINTAINER Milan Sulc <sulcmil@gmail.com>

ADD ./packagist-schema.xml /opt/solr/server/solr/configsets/data_driven_schema_configs/conf/managed-schema

VOLUME /opt/solr/server/solr/mycores

CMD ["docker-entrypoint.sh", "solr-precreate", "packagist"]

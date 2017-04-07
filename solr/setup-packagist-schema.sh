#!/bin/sh

SCHEMA=/packagist-schema.xml
COLLECTION=/opt/solr/server/solr/mycores/packagist
MANAGED_SCHEMA=${COLLECTION}/managed-schema

echo "Copy ${SCHEMA} to ${MANAGED_SCHEMA}"
cp "${SCHEMA}" "${MANAGED_SCHEMA}"

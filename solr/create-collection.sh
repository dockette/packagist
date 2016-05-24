#!/bin/bash

/opt/solr/bin/solr create_core -c packagist

cp /managed-schema /opt/solr/server/solr/packagist/conf/managed-schema

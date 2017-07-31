#!/bin/bash
WIKI_IP=`docker inspect \
	-f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
	mediawikidocker_web_1`
docker exec mediawikidocker_parsoid_1 bash -c "echo \"$WIKI_IP wiki\" >> /etc/hosts"

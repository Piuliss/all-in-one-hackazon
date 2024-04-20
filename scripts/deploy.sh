#!/bin/bash

# Eliminar el servicio y stack existente
docker service rm fiuni_web

# Esperar unos segundos para que se eliminen correctamente
sleep 20

# Implementar el stack en Swarm
docker stack deploy --compose-file ../docker-compose.yml fiuni
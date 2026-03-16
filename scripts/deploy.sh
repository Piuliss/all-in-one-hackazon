#!/bin/bash

echo "Removing fiuni_web service"
# Eliminar el servicio y stack existente
docker service rm fiuni_web
echo "Waiting for 20 seconds ..."
# Esperar unos segundos para que se eliminen correctamente
sleep 20
echo "Deploy stack again..."
# Implementar el stack en Swarm
docker stack deploy --compose-file ../docker-compose.yml fiuni
echo "Done"
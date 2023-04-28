#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

docker build -t ghcr.io/ondfisk/fine-collection-service:latest $SCRIPT_PATH/../src/FineCollectionService
docker push ghcr.io/ondfisk/fine-collection-service:latest

docker build -t ghcr.io/ondfisk/traffic-control-service:latest $SCRIPT_PATH/../src/TrafficControlService
docker push ghcr.io/ondfisk/traffic-control-service:latest

docker build -t ghcr.io/ondfisk/vehicle-registration-service:latest $SCRIPT_PATH/../src/VehicleRegistrationService
docker push ghcr.io/ondfisk/vehicle-registration-service:latest

docker build -t ghcr.io/ondfisk/simulation:latest $SCRIPT_PATH/../src/Simulation
docker push ghcr.io/ondfisk/simulation:latest

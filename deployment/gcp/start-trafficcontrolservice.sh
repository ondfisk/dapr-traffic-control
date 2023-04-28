#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PORT=6001

dapr run \
    --app-id trafficcontrolservice \
    --app-port $PORT \
    --resources-path ./dapr/components \
    --config ./dapr/config/config.yaml \
    -- dotnet run --urls http://localhost:$PORT --project $SCRIPT_PATH/../../src/TrafficControlService

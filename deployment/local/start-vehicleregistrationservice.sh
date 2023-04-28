#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PORT=6003

dapr run \
    --app-id vehicleregistrationservice \
    --app-port $PORT \
    --resources-path ./local/dapr/components \
    --config ./local/dapr/config/config.yaml \
    -- dotnet run --urls http://localhost:$PORT --project $SCRIPT_PATH/../../src/VehicleRegistrationService

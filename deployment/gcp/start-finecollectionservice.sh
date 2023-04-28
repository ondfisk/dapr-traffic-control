#!/bin/bash

export FINE_CALCULATOR_LICENSE_SECRET_NAME=finecalculator_licensekey
export FINE_CALCULATOR_LICENSE_SECRET_KEY=finecalculator_licensekey

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PORT=6002

dapr run \
    --app-id finecollectionservice \
    --app-port $PORT \
    --resources-path ./dapr/components \
    --config ./dapr/config/config.yaml \
    -- dotnet run --urls http://localhost:$PORT --project $SCRIPT_PATH/../../src/FineCollectionService

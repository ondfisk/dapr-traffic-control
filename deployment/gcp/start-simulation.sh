#!/bin/bash

export TRAFFIC_CONTROL_ENDPOINT="http://localhost:6001"

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

dotnet run --project $SCRIPT_PATH/../../src/Simulation

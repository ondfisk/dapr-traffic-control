#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PORT=5000

dotnet run --project $SCRIPT_PATH/../../src/VisualSimulation  --urls "http://localhost:$PORT"

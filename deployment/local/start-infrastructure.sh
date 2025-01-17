#!/bin/bash

# Initialize Dapr if script was called with --init
if [ "$1" == "--init" ]; then
    echo "Initializing Dapr..."
    dapr init
fi

docker run -d -p 5672:5672 -p 15672:15672 --name dtc-rabbitmq rabbitmq:3-management-alpine

docker run -d -p 1080:1080 -p 1025:1025 --name dtc-maildev maildev/maildev:2.0.5

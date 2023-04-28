#!/bin/bash

docker run -d -p 1080:1080 -p 1025:1025 --name dtc-maildev maildev/maildev:2.0.5

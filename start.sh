#!/bin/bash
-e

docker build -t test_spark .
docker run --rm -it -p 9870:9870 test_spark
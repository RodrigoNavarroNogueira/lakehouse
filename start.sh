#!/bin/bash
set -e

docker build -t hadoop_spark .
docker run --rm -it -v /home/ubuntu/repos/lakehouse/dev:/abacaxi -p 9870:9870 -p 8088:8088 -p 10000:10000 hadoop_spark bash
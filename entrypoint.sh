#!/bin/sh

set -e

MASTER1_PORT=$1
MASTER2_PORT=$2
MASTER3_PORT=$3
SLAVE1_PORT=$4
SLAVE2_PORT=$5
SLAVE3_PORT=$6
SLEEP_DURATION=${SLEEP_DURATION:-5} # Use 5 as the default if not provided

# Ensure that SLEEP_DURATION is treated as an integer
SLEEP_DURATION=$((SLEEP_DURATION))

docker_run="docker run -d -p ${MASTER1_PORT}:6379 -p ${MASTER2_PORT}:6380 -p ${MASTER3_PORT}:6381 -p ${SLAVE1_PORT}:6382 -p ${SLAVE2_PORT}:6383 -p ${SLAVE3_PORT}:6384 --name redis-cluster abraaolevi/docker-redis-cluster-arm"

sh -c "$docker_run"

# Wait for Redis Cluster to be up and running
echo "Waiting for Redis Cluster to start..."
until docker exec redis-cluster redis-cli -h localhost -p 6379 cluster info; do
    echo "Sleep duration of: $SLEEP_DURATION"
    sleep "$SLEEP_DURATION"
done

# Perform additional health check here if needed
# For example, you can check if all nodes are available and part of the cluster

echo "Redis Cluster is up and running!"

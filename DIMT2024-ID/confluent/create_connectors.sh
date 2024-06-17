#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source ${DIR}/../.env

confluent environment use ${ENV_ID}
confluent kafka cluster use ${CLUSTER_ID}

confluent connect cluster create --config-file actual_datagen_clickstream.json
confluent connect cluster create --config-file actual_datagen_shoe_customers.json
confluent connect cluster create --config-file actual_datagen_shoe_orders.json
confluent connect cluster create --config-file actual_datagen_shoes.json

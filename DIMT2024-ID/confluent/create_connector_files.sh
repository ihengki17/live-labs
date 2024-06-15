#! /bin/bash

echo "generating connector configuration json files from .env"
echo

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source ${DIR}/../.env

for i in example_datagen_clickstream.json example_datagen_shoe_customers.json example_datagen_shoe_orders.json example_datagen_shoes.json; do
    sed -e "s|<add_your_api_key>|${CCLOUD_API_KEY}|g" \
    -e "s|<add_your_api_secret_key>|${CCLOUD_API_SECRET}|g" \
    ${DIR}/$i > ${DIR}/actual_${i#example_}
done

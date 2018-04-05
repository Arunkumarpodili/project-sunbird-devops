#!/bin/sh
set -e

if [ "$#" -ne 1 ]; then
    echo "ERROR: Illegal number of parameters"
    echo "Usage: $0 <inventory-path>"
    exit 1
fi

INVENTORY_PATH=$1

ORG=sunbird
ECHO_SERVER_VERSION=1.5.0-gold
ADMIN_UTILS_VERSION=1.5.0-gold

# Bootstrap swarm
echo "@@@@@@@@@ Bootstrap swarm"
ansible-playbook -i $INVENTORY_PATH ../ansible/bootstrap.yml  --extra-vars "hosts=swarm-manager" --tags bootstrap_swarm --extra-vars=@config -vv

#Deploy API Manager
echo "@@@@@@@@@ Deploy API Manager"
ansible-playbook -i $INVENTORY_PATH ../ansible/deploy.yml --tags "stack-api-manager" --extra-vars "hub_org=${ORG} echo_server_image_name=echo-server echo_server_image_tag=${ECHO_SERVER_VERSION}" --extra-vars=@config --connection local

# Deploy Admin Utils API
echo "@@@@@@@@@ Deploy Admin Utils API"
ansible-playbook -i $INVENTORY_PATH ../ansible/deploy.yml --tags "stack-adminutil" --extra-vars "hub_org=${ORG} image_name=adminutil image_tag=${ADMIN_UTILS_VERSION}" --extra-vars=@config


#!/bin/sh

TERRAFORM_STATE_FILE=terraform.tfstate
CERT=$(jq ".outputs.thing_cert_pem.value" < ${TERRAFORM_STATE_FILE} | tr -d '"' )
KEY=$(jq ".outputs.thing_key_pem.value" < ${TERRAFORM_STATE_FILE}| tr -d '"')

# shellcheck disable=SC2039
echo -e "$CERT"> certs/thing1.crt.pem
# shellcheck disable=SC2039
echo -e "$KEY" > certs/thing1.key.pem
wget -O certs/AmazonRootCA1.pem "https://www.amazontrust.com/repository/AmazonRootCA1.pem"

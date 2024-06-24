#!/bin/bash
set -eu 
mkdir /root/.aws
envsubst '${AWS_KEY} ${AWS_SECRET} ${AWS_PROFILE} ${AWS_ACCESS_KEY_ID} ${AWS_SECRET_ACCESS_KEY}'  < /templates/credentials.template > /root/.aws/credentials
envsubst '${AWS_PROFILE} $ ${AWS_REGION}' < /templates/config.template > /root/.aws/config
exec "$@"
#!/usr/bin/env bash

echo "===> Vault provision"
# Get wrapped secret id
WRAPPED_VAULT_TOKEN_JSON=$(curl -s -X POST $BROKER_URL/v1/provision/approle/secret-id \
    -H 'X-Broker-Token: '"$ACTION_TOKEN"'' \
    -H 'X-Vault-Role-Id: '"$PROVISION_ROLE_ID"'' \
)
if [ "$(echo $WRAPPED_VAULT_TOKEN_JSON | jq '.error')" != "null" ]; then
    echo "Exit: Error detected"
    echo $WRAPPED_VAULT_TOKEN_JSON | jq '.'
    exit 1
fi
WRAPPED_VAULT_APPROLE_SECRET_ID_TOKEN=$(echo $WRAPPED_VAULT_TOKEN_JSON | jq -r '.wrap_info.token')
echo "::add-mask::$WRAPPED_VAULT_APPROLE_SECRET_ID_TOKEN"
echo "WRAPPED_VAULT_APPROLE_SECRET_ID_TOKEN=$WRAPPED_VAULT_APPROLE_SECRET_ID_TOKEN" >> $GITHUB_ENV

echo "Success"
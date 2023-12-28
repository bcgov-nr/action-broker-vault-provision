# Broker Action Vault Provision V1

This action calls the Vault API to provision a secret for use by an application to login together with the service's role id. See: [Vault API - Login with AppRole](https://developer.hashicorp.com/vault/api-docs/auth/approle#login-with-approle)

This action is provided to illustrate how to call the Broker API. The [Vault Login Action](https://github.com/bcgov-nr/action-broker-vault-login) may be a better choice.

## Vault Login or Vault Provision

This action creates an AppRole secret which can be used to login and create a Vault token that can be renewed. This is required if you want your service to have continuous access to a database protected by a dynamic (rotated) secret (See: [Vault database engine](https://developer.hashicorp.com/vault/docs/secrets/databases)). Otherwise, you would only be able to start a service that could access the database using that dynamic secret for the duration of the intention.

Each invocation of this action should, at most, provision a single instance of a service. How a service is provisioned should not create a scenario where its token outlives the service instance. If multiple service instances are provisioned with the same token from a single invocation, an immortal shared token (if each individual service renews the same token) is created. Secure token renewal depends on the token expiring (relatively) quickly once a service instance is stopped.

In almost all situations, a GitHub Action should be using the [Vault Login Action](https://github.com/bcgov-nr/action-broker-vault-login) instead.

# Broker Documentation

Please refer to the [NR Broker Repository](https://github.com/bcgov-nr/nr-broker) for full usage details.

# Usage

<!-- start usage -->
```yaml
- uses: bcgov-nr/action-broker-vault-revoke@v1
  with:
    # The token of the action containing the service to use to login as
    action_token: ''

    # The broker url.
    # Default: 'https://nr-broker.apps.silver.devops.gov.bc.ca'
    broker_url: ''

    # The service's application role id in vault. Setting this is recommended to avoid environment mismatch.
    role_id: ''

    # The vault url.
    # Default: https://knox.io.nrs.gov.bc.ca
    vault_url: ''
```
<!-- end usage -->

# Output

This action outputs the wrapped Vault secret id as an environment variable.

### WRAPPED_VAULT_APPROLE_SECRET_ID_TOKEN

This is a wrapped Vault secret id that can be used to access the service's secrets by logging in using the AppRole. The unwrapping API (/v1/sys/wrapping/unwrap) will return the secret id as the field, secret_id.

# License

The scripts and documentation in this project are released under the [Apache License](LICENSE)


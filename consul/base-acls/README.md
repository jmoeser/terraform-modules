- Run this
- Get agent token from Consul
- Add to Consul config:
```
  "acl": {
    "enabled": true,
    "tokens": {
      "agent": "<TOKEN>"
    }
  },
```
- Get Vault token, add to it's storage backend
- Get Terraform token, set it in config for remote state

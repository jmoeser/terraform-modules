#!/bin/sh

export VAULT_CACERT=$PWD/vault-certs/vault-ca.crt

vault operator init | tee init_output > /dev/null

KEY_1=$(grep "Key 1" init_output | awk '{print $4}')
KEY_2=$(grep "Key 2" init_output | awk '{print $4}')
KEY_3=$(grep "Key 3" init_output | awk '{print $4}')
ROOT_TOKEN=$(grep "Root Token" init_output | awk '{print $4}')

vault operator unseal "$KEY_1"
vault operator unseal "$KEY_2"
vault operator unseal "$KEY_3"

printf '%s' "$ROOT_TOKEN" | vault login - > /dev/null

shred init_output -u

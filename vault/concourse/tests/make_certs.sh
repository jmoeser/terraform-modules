#!/bin/sh

if [ ! -d 'vault-certs' ]; then
    certstrap init --cn vault-ca --passphrase ''
    certstrap request-cert --domain vault --ip 127.0.0.1 --passphrase ''
    certstrap sign vault --CA vault-ca
    certstrap request-cert --cn concourse --passphrase ''
    certstrap sign concourse --CA vault-ca
    mv out vault-certs
fi

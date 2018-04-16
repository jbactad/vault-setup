#! /bin/env bash

set -x

logger() {
    DT=$(date '+%Y/%m/%d %H:%M:%S')
    echo "$DT $0: $1"
}

DIR=$(dirname "$0")

vault operator init -key-shares=1 -key-threshold=1
vault operator unseal
vault auth enable approle
vault policy write goldfish ${DIR}/../policies/goldfish.hcl

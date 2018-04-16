# [mandatory]
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "auth/token" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

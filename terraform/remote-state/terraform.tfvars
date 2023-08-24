project_name     = "goproject"
application_name = "goproject123"
reviewers        = ["mark@foo.com"]

project = {
  environments = {
    dev = {
      reviewers = ["mark@foo.com"]
      azure_credentials = {
        client_id       = "foo"
        client_secret   = "foo"
        tenant_id       = "foo"
        subscription_id = "foo"
      }
      azure_backend = {
        resource_group  = "foo"
        storage_account = "foo"
        container       = "foo"
      }
    }
  }
}

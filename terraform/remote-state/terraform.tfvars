project_name     = "goproject"
application_name = "goproject123"
reviewers        = ["mark@foo.com"]
dev_subscription = {
  client_id       = "foo"
  client_secret   = "foo"
  tenant_id       = "foo"
  subscription_id = "foo"
}
dev_backend = {
  resource_group  = "foo"
  storage_account = "foo"
  container       = "foo"
}
prod_subscription = {
  client_id       = "foo"
  client_secret   = "foo"
  tenant_id       = "foo"
  subscription_id = "foo"
}
prod_backend = {
  resource_group  = "foo"
  storage_account = "foo"
  container       = "foo"
}

org_setup = {
  projects = {
    myproject1 = {
      environments = {
        dev = {
          reviewers        = ["mark@foo.com"]
          subscription = {
            client_id       = "foo"
            client_secret   = "foo"
            tenant_id       = "foo"
            subscription_id = "foo"
          }
          backend = {
            resource_group  = "foo"
            storage_account = "foo"
            container       = "foo"
          }
        }
        prod = {
          reviewers        = ["tom@foo.com"]
          subscription = {
            client_id       = "foo"
            client_secret   = "foo"
            tenant_id       = "foo"
            subscription_id = "foo"
          }
          backend = {
            resource_group  = "foo"
            storage_account = "foo"
            container       = "foo"
          }
        }
        prod = {
          subscription = {
            client_id       = "foo"
            client_secret   = "foo"
            tenant_id       = "foo"
            subscription_id = "foo"
          }
          backend = {
            resource_group  = "foo"
            storage_account = "foo"
            container       = "foo"
          }
        }
      }
    }        
    myproject2 = {
      environments = {
        dev = {
          reviewers        = ["bob@foo.com"]
          subscription = {
            client_id       = "foo"
            client_secret   = "foo"
            tenant_id       = "foo"
            subscription_id = "foo"
          }
          backend = {
            resource_group  = "foo"
            storage_account = "foo"
            container       = "foo"
          }
        }
      }
    }
  }
}


variable "dev_subscription" {
  type = object({
    client_id       = string
    client_secret   = string
    tenant_id       = string
    subscription_id = string
  })
}
variable "dev_backend" {
  type = object({
    resource_group  = string
    storage_account = string
    container       = string
  })
}
variable "prod_subscription" {
  type = object({
    client_id       = string
    client_secret   = string
    tenant_id       = string
    subscription_id = string
  })
}
variable "prod_backend" {
  type = object({
    resource_group  = string
    storage_account = string
    container       = string
  })
}

variable "project_name" {
  type = string
}
variable "application_name" {
  type = string
}
#variable "backend" {
#  type = object({
#    resource_group  = string
#    storage_account = string
#    container       = string
#  })
#}
#variable "subscription" {
#  type = object({
#    client_id       = string
#    client_secret   = string
#    tenant_id       = string
#    subscription_id = string
#  })
#}
variable "reviewers" {
  type = list(any)
}
variable "org_setup" {
  type = map(
    map(
      map(
        object({
          reviewers = list(string)
          subscription = object({
            client_id       = string
            client_secret   = string
            tenant_id       = string
            subscription_id = string
          })
          backend = object({
            resource_group  = string
            storage_account = string
            container       = string
          })
        })
      )
    )
  )
}

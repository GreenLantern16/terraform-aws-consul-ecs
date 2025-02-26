provider "aws" {
  region = "us-west-2"
}

module "test_client" {
  source = "../../../../../../modules/mesh-task"
  family = "family"
  container_definitions = [{
    name = "basic"
  }]
  outbound_only          = true
  retry_join             = ["test"]
  acls                   = true
  acl_secret_name_prefix = "foo"
}

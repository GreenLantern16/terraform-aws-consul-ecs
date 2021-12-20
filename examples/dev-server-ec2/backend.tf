terraform {
  backend "remote" {
    organization = "PublicSector-ATARC"

    workspaces {
      name = "terraform-aws-consul-ecs"
    }
  }
}

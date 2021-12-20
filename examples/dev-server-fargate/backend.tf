terraform {
  backend "remote" {
    organization = "PublicSector-ATARC"

    workspaces {
      name = "fse-terraform-aws-consul-ecs"
    }
  }
}

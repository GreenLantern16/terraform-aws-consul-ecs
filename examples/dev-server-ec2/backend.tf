terraform {
  backend "remote" {
    organization = "PublicSector-ATARC"

    workspaces {
      name = "fse-tf-atarc-aws-ecs-vpc"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  name = "consul-ecs-${random_string.suffix.result}"
}

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "random_shuffle" "azs" {
  input = data.aws_availability_zones.available.names
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"

  name = local.name
  cidr = "10.0.0.0/16"
  // The NAT gateway limit is per AZ. With `single_nat_gateway = true`, the NAT gateway is created
  // in the first public subnet. Shuffling AZs helps spread NAT gateways across AZs to help with this.
  azs = [
    // Silly, but avoids this error: `"count" value depends on resource attributes that cannot be determined until apply`
    random_shuffle.azs.result[0],
    random_shuffle.azs.result[1],
    random_shuffle.azs.result[2],
  ]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  tags                 = var.tags
}

resource "aws_ecs_cluster" "this" {
  name               = local.name
  capacity_providers = var.launch_type == "FARGATE" ? ["FARGATE"] : null
  tags               = var.tags
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = local.name
  tags = var.tags
}

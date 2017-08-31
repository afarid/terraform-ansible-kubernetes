provider "aws" {
  region = "${var.region}"
}

#Create subnets that should we run ec2 instanes IN
module "vpc_subnets" {
  source = "./modules/vpc_subnets"
  enable_dns_support = true
  enable_dns_hostnames = true
  vpc_cidr = "172.16.0.0/16"
  public_subnets_cidr = "172.16.10.0/24,172.16.20.0/24"
  private_subnets_cidr = "172.16.30.0/24,172.16.40.0/24"
  azs = "${lookup(var.azs, var.region)}"
}

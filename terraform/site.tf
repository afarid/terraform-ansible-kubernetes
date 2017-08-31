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

#Create ssh key to be abale to login ec2 instances
module "ec2key" {
  source = "./modules/ec2key"
  key_name = "${var.cluster_name}"
  public_key = "${var.public_key}"
}

#Create security group for ssh access
module "ssh_sg" {
  source = "./modules/ssh_sg"
  name = "${var.cluster_name}_ssh_sg"
  vpc_id = "${module.vpc_subnets.vpc_id}"
  source_cidr_block = "0.0.0.0/0"
}


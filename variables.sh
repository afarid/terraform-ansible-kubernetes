#!/usr/bin/env bash
export TF_VAR_region=us-east-1
# Define kube cluseter name
export TF_VAR_cluster_name=kube02
# Define public key value for your ssh-key
export TF_VAR_public_key=`cat ~/.ssh/id_rsa.pub`
#Define ec2 instance type
export TF_VAR_instance_type=t2.micro



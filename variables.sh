#!/usr/bin/env bash
export TF_VAR_region=us-east-1
# Define ssh key name
export TF_VAR_cluster_name=test123
# Define public key value for your ssh-key
export TF_VAR_public_key=`cat ~/.ssh/id_rsa.pub`


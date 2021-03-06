## Install Kubernetes cluster using Terraform and ansible

### Requirements:

- Docker installed 
- AWS admin access

### Tools Used:
```shell
docker --version
Docker version 17.06.0-ce, build 02c1d87
```

#### How to install and deploy

1- Make sure that you have created ssh keys inside you home directory as they will be used for ansible to configure instances
```bash
ls -l   ~/.ssh
total 60
-rw------- 1 bamboo bamboo  1679 مار 21 14:14 id_rsa
-rw-r--r-- 1 bamboo bamboo   407 مار 21 14:14 id_rsa.pub
-rw-r--r-- 1 bamboo bamboo 46168 ماي  1 04:01 known_hosts

```

2- Launch A docker container is prepared with all tools to launch the envinment
```bash
 sudo docker run -it -v ~/.ssh:/root/.ssh/ -v $PWD/:/source amrfarid/tac /bin/bash
```

3- you need to export `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as environment variables, Consider change below values to yours

```
export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="yyyyyyyyyyyyyyyyyyyyyyy"
export AWS_DEFAULT_REGION=us-east-1
```

4- Edit variables file, Define AWS region, Name for launched stack, EC2 Instance type, Database password, and S3 bucket name you want to create to upload backup to.  
```bash
cd /source
vim variables.sh
 
#!/usr/bin/env bash
export TF_VAR_region=us-east-1
# Define kube cluser name, it must be unique
export TF_VAR_cluster_name=test123
# Define public key value for your ssh-key
export TF_VAR_public_key=`cat ~/.ssh/id_rsa.pub`
#Define ec2 instance type
export TF_VAR_instance_type=t2.micro
```

````source variables.sh````

5- To build your environment:
```
cd terraform
source ../variables.sh
terraform init && terraform get && terraform plan && terraform apply
```
#### Above terraform plan will do: 
- Create 1 x VPC with 4 x VPC subnets
- Create the AWS key pair with the provided public key
- Create 1 x security group for each(SSH,Webservers)
- Provision 4 x EC2 instances(Ubuntu 16.04 LTS) 


```bash
cd /source/ansible/
ansible-playbook -i inventory.py playbook.yml -u ubuntu -s

```

#### Above Ansible playbook will do: 
- Install docker on all provisioned instances by terrafrom
- Install Kubernetes on master and minions
- Join Miniions to the master
  
##### To list all provisioned instances
 
 ```bash
./inventory.py

```
#### To check the status of the cluster
 
 ```bash
 # Get the public ip of kube master
 ./inventory.py

 # Remote login to master
 ssh ubuntu@<master public ip>

 #Swich to root user
 sudo su -

 # List kube nodes
 kubectl get nodes

 # Alle nodes should be in ready state
 NAME               STATUS    AGE       VERSION
ip-172-16-10-13    Ready     1m        v1.7.5
ip-172-16-10-142   Ready     2m        v1.7.5
ip-172-16-10-228   Ready     1m        v1.7.5
ip-172-16-20-232   Ready     1m        v1.7.5

```

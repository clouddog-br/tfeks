# Caution

The .gitignore file is ignoring the backend.tf
if you fork the repository make sure to comment the backend.tf

# The Project

This repository is a lab to test Terraform/OpenTofu with EKS

## TF Providers

- hashicorp/aws
- hashicorp/helm
- hashicorp/kubernetes
- gavinbunney/kubectl
- cloudposse/tfstate-backend/aws
- and more on each module

## Modules

### VPC

[README](modules/vpc/README.md)

### EKS

[README](modules/eks/README.md)

### EBS CSi Driver

[README](eks-ebs-csi-driver/README.md)

### EKS External Secrets

[README](modules/eks-external-secrets/README.md)

### EKS Load balancer controller

[README](modules/eks-load-balancer-controller/README.md)

### EKS RBAC default roles

[README](modules/eks-rbac-default-roles/README.md)

### Role create eks

[README](role-create-eks/README.md)


# How to start

## Prepare your project

This command will install the providers needed for the project

```
terraform init
```

Prepare your profile aws cli credentials and set the profile to be used by terraform

```
export AWS_PROFILE=my_profile_name
```

## Create the tfvars file

Rename the terraform.tfvars.example file to terraform.tfvars. It has the a sample to use the project

```
mv terraform.tfvars.example terraform.tfvars
```

### Creating the storage for tfstate and lock

Follow the steps on folder [state-and-lock](./state-and-lock/README.md) and create a S3 and DynamoDB to use on tf

### Create a role before create the EKS

Follow the steps on folder [role-create-eks](./role-create-eks/README.md) and create a role to create the EKS Cluster

### Remove the assumed role after create the EKS

Create the EKS with the role .

Go to folder role-create-eks and delete the role

```
cd role-create-eks
terraform destroy
```

Return to main project

```
cd ../
```


## Analyse the changes

This command will show the plan of execution with all changes

```
terraform plan -var-file ENV_NAME.tfvars
```

## Apply all changes

### Create workspaces for the environments

Before create the resources, create a workspace to environment

terraform workspace new ENV_NAME

ex:
```
terraform workspace new dev
terraform workspace new stg
terraform workspace new prd
```


### Change between workspaces

Before create the resources, create a workspace to environment

terraform select ENV_NAME

ex
```
terraform select dev
```


### Create / Apply the changes on environment

This command will apply all changes maide in your IaC tf files to your environment

```
terraform apply -var-file ENV_NAME.tfvars
```

ex:
```
terraform apply -var-file test.tfvars
terraform apply -var-file dev.tfvars
terraform apply -var-file stg.tfvars
terraform apply -var-file prd.tfvars
```


# how to remove everything?

For exclude everything, first remove all modules to your cluster.


```
kubectl delete --all virtualgateways.appmesh.k8s.aws --all-namespaces
kubectl delete --all virtualrouters.appmesh.k8s.aws --all-namespaces
kubectl delete --all virtualservices.appmesh.k8s.aws --all-namespaces
kubectl delete --all virtualnodes.appmesh.k8s.aws --all-namespaces
kubectl delete --all deployments --namespace=dev
kubectl delete --all deployments --namespace=yelb
kubectl delete --all ingress --namespace=monitoring
kubectl delete --all deployments --namespace=monitoring
kubectl delete --all deployments --namespace=monitoring
```

Comment everything, except VPC and EKS on main.tf and run:

```
terraform apply -var-file ENV_NAME.tfvars
```

after removed all modules with terraform apply, use the command:

```
terraform destroy
```

# Configuring Lens

open the cluster on lens, go to settings, metrics.

Fullfill the fields with:
Prometheus: Helm
Prometheus Service Address: monitoring/prometheus-server:80


# Import existing namespace

Example to import a existing namespace to terraform state

terraform import 'kubernetes_namespace.es_secret_store_namespace["NAMESPACE_NAME"]' NAMESPACE_NAME

ex:

```
terraform import 'kubernetes_namespace.es_secret_store_namespace["yelb"]' yelb
```

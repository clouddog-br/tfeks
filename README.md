# Caution

The .gitignore file are not ignoring the .tfvars and is ignoring the backend.tf
if you fork the repository make sure to uncomment the .tfvars and comment the backend.tf

# The Project

This repository is a lab to test Terraform/OpenTofu with EKS

## TF Providers

- hashicorp/aws
- hashicorp/helm
- hashicorp/kubernetes
- gavinbunney/kubectl
- terraform-aws-modules/eks/aws
- terraform-aws-modules/eks/aws//modules/karpenter

## Modules

### VPC

[README](modules/vpc/README.md)

### EKS

[README](modules/eks/README.md)


# How to start

## Prepare your project

This command will install the providers needed for the project

```
terraform init
```

### Creating the storage for tfstate and lock

To work as a team, and to the CI/CD is important to save the tfstate file of each environment

To work with the team, is important create a lock beatween everyone to noone run as same time the cloudformation, but create a pipeline is the best option

To save the state on S3 and use the dynamodb as lock, see the file tf-backend.tf and tf-backend-outputs.tf

Edit the tf-backend.tf with your informations. See the information of module: [cloudposse/tfstate-backend](https://registry.terraform.io/modules/cloudposse/tfstate-backend/aws/latest)

```
code tf-backend.tf
```

Run the apply for this resource to create the TF backend file

```
terraform apply -target=module.terraform_state_backend
```

After runned it, verify your backend.tf file

```
cat backend.tf
```

After verify the configuration generated by the module, run the init again to load the configuration

```
terraform init -force-copy
```


## Analyse the changes

This command will show the plan of execution with all changes

```
terraform plan
```

## Apply all changes

This command will apply all changes maide in your IaC tf files to your environment

```
terraform apply
```

# how to remove everything?

For exclude everything, use this command:

```
terraform destroy
```

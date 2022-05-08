# Terraform
## 1 Evolution of Cloud + Infrastructure as Code
* Pre cloud companies needed to host own infrastrustcture and go to server to deploy
* Now, can use on demand on cloud and not need to own hardware
* Can deploy now your infra using apis and commands, that perform fast, scale up and down easily
* Infra is now short lived and immutable, instead of having a long lives owned infra

### 1.1 Provision Cloud Resources
* Via GUI interface
* Via API/CLI commands
* IaC -> Declarative files with traceability, confidence, replicable

### 1.2 What is IaC?
* Categories
    * Ad Hoc Scipts
    * Configuration Management Tools - Ansible
    * Server Templating Tool - AMI, amazon machine 
    * Orchestration Tools - Kubernetes
    * Provisioning Tools - Call out tools to deploy Infra on cloud
        * Declarative - define end state of what you want (5 servers, 1 load balancer), not tell the steps
        * Imperative - Tell the system what you want to happen and the steps

### 1.3 IaC Provisioning Tools Landscape
* Cloud Specific
    * Cloud Formation
    * Azure Resource Manage
    * Google Cloud Deployment Manager
* Cloud Agnostic
    * Used across any cloud
    * Terraform
    * Pulumi
    * Can interact with anything with an API

## 2 - Overview + Setup
* It is owned by Hashicorp
* Tool for building, changing and versioning infrastructure safely and efficiently
* It is an IaC tool
* Enables application software best practices to infrastructure
* Compatible with many clouds and services

### 2.1 Common Patterns
* Terraform is commonly used with other tools
* Terraform for Provisioning (provision 5 VMs) + Ansible for Config Management (install dependencies on the machines)
* Terraform for Provisioning (provision 5 VMs) + Server Templating (to deploy the VMs with a specific template)
* Terraform for Provisioning (provision 5 VMs) + Kubernetes (To manage how the deployment is used and orchestrated)

### 2.2 Overview Architecture

ARCHITECTURE IMAGE

* Terraform Core - heart of the service, communicate with Terraform State and fecth configs from Terraform Config
* Core use both files and communicate with providers to map the desired state according to the service to be deployes
* There are currently more than a 100 providers

### 2.3 Setup
* Install Terraform
    * Official installation instructions from HashiCorp: https://learn.hashicorp.com/tutorials/terraform/install-cli
* AWS Account Setup
    * AWS Terraform provider documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication
    * create non-root AWS user in IAM
    * Add the necessary IAM roles (e.g. AmazonEC2FullAccess)
        * AmazonRDSFullAccess
        * AmazonEC2FullAccess
        * IAMFullAccess
        * AmazonS3FullAccess
        * AmazonDynamoDBFullAccess
        * AmazonRoute53FullAccess
    * Save Access key + secret key (or use AWS CLI aws configure -- https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

* I installed:
    * brew install terraform
* Install AWS CLI https://aws.amazon.com/cli/
* After go to your preferred folder and config the aws cli:
    * type aws configure
    * pass the asked values (we got from previous step)
    * choose your default region and output format as json
    * All configured

### 2.4 First Terraform Deployment
* In folder first-tf-deployment/main.tf there is the minimal version a of a terraform deployment
* go to the folder with the main.tf and run
* terraform init - this initialize the terraform backend
* terraform plan - This will show the current state and the final state after you aplpy it
* terraform apply - create instances
* terraform destroy - clean up everything
## 3 - Basics
Covers main usage pattern, setting up remote backends (where the terraform state is stored) using terraform Cloud and AWS, and provides a naive implementation of a web application architecture.

### 3.1 Basic Sequence
* terraform init - this initialize the terraform backend
* terraform plan - This will show the current state and the final state after you aplpy it
* terraform apply - really create the resources
* terraform destroy - clean up everything

### 3.2 Providers
* Can search for a lot 
* Each provider can be tagged as official and have a lot resources to be deployed
* You specify the providers on the top of main.tf and also can pass some other infos, like regions and so on
* AWS provider -> https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication

### 3.3 Terrafom init
* Init
    * when run, it downloads all dependencies for the provider version selected
    * store in a hidden folder callend terraform
    * Also creates a lock file containing info about specific dependencies for the workspace
    * It would also download the modules (we se more later)
    * Create the terraform.tfstate
        * representation oth the world
        * all info about every resource and objects
        * can contain sensitive info like password for a database created on the fly
        * can be stored locally or remotelly
    * the local backend having the state file locally is the default
    * Simple to get started
    * bad because sensitive values in plain text
    * also uncollaborative and require manual work
    * The remote backend state file is better hosted on a cloud provider (S3, bucket, terraform cloud)
    * Then sensitive data is encrypted
    * Collaboration is possible and automation is easier
    * the con: incrase the complexity slightly

### 3.4 Terraform plan
* Compare the current terraform config to the terraform state (actual state)
* It will not deploy duplicated resources
* If in the config I have 5 servers but in the config I have 4, it will plan +1 extra server only

### 3.4 Terraform destroy
* Clean up everything on the current project
* usually not used in production environment
* used to clean up dev environments

### 3.5 Remote backend
* Terraform Cloud
    * simple ans easy to start
    * free up to 5 users
    * after 20$/month per user
    * This is how they make money
* AWS - self managed backend
    * specify s3 bucket - where files will live
    * specify dynamo db where the locking and configs will be stated
    * can encrypt it
    * locks are used to take advantage of atomic guarantee from dynamo that only one transaction will happen at a moment
    * one transaction need to be finished before other start. This assure 2 terraform commands will not run together and try to change states
* to create an AWs backend, add this section inside terraform on main.tf 
    * see file in folder 3-remote-backend
```json
terraform {
    backend "s3" {
    bucket         = "devops-directive-tf-state" # REPLACE WITH YOUR BUCKET NAME
    key            = "03-basics/import-bootstrap/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
    }
}
```
### 3.6 Setup Remote Backend
* This is a trick, how to setup a remote backend that needs a bucket and db that still not exist?
* Usually we first deploy from local without specifyng the resources
    * dynamo db + s3 bucket
* first we wun with the section below commented, after deploy we can uncomment and refer the back end
```json
terraform {
  #############################################################
  ## AFTER RUNNING TERRAFORM APPLY (WITH LOCAL BACKEND)
  ## YOU WILL UNCOMMENT THIS CODE THEN RERUN TERRAFORM INIT
  ## TO SWITCH FROM LOCAL BACKEND TO REMOTE AWS BACKEND
  #############################################################
  # backend "s3" {
  #   bucket         = "devops-directive-tf-state" # REPLACE WITH YOUR BUCKET NAME
  #   key            = "03-basics/import-bootstrap/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-locking"
  #   encrypt        = true
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "devops-directive-tf-state" # REPLACE WITH YOUR BUCKET NAME
  force_destroy = true
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
    # ecnryption
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID" # important to be like this
  attribute {
    name = "LockID"
    type = "S"
  }
}
```
### 3.7 Web App project
IMAGE ARCHITECTURE

* Amazon Route S3 -> used to ope the ports and receive external traffic
* Elastic Load Balancing -> it receives the traffic request and balance to most avalaiable instance
* Amazon EC2 -> Deployed a group of 2 Compute instances that returns a message
* S3 -> sample, not really used in this architecture
* Amazon RDS -> sample, not really used in this architecture

After all deployed, since we do not own the domain and cant route the amazon route domain to our owned domain we can test the deployment by going to Load Balancer and pasting ist link on the url. Refresh a couple times and see it balancing to different EC2


## 04 - Variables and Outputs
Introduces the concepts of variables which enable Terraform configurations to be flexible and composable. Refactors web application to use these features.

## 05 - Language Features
Describes additional features of the Hashicorp Configuration Language (HCL).

## 06 - Organization and Modules
Demonstrates how to structure terraform code into reuseable modules and how to instantiate/configure modules.

## 07 - Managing Multiple Environments
Shows two methods for managing multiple environments (e.g. dev/staging/prodution) with Terraform.

## 08 - Testing
Explains different types of testing (manual + automated) for Terraform modules and configurations.

## 09 - Developer Workflows + CI/CD
Covers how teams can work together with Terraform and how to set up CI/CD pipelines to keep infrastructure environments up to date.
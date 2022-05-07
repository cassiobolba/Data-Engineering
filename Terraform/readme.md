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


## 03 - Basics
Covers main usage pattern, setting up remote backends (where the terraform state is stored) using terraform Cloud and AWS, and provides a naive implementation of a web application architecture.

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
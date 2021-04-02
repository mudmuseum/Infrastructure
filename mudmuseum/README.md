# Infrastructure repository for MudMuseum

- Terraform@0.14.9 and Terraspace@0.6.5 to setup AWS Account
- GitHub management
- Ansible configuration

# Terraspace Project

This is a Terraspace project. It contains code to provision Cloud infrastructure built with [Terraform](https://www.terraform.io/) and the [Terraspace Framework](https://terraspace.cloud/).

## Deploy

To deploy all the infrastructure stacks:

    terraspace all up

To deploy individual stacks:

    terraspace up s3-mudmuseum_com

## Terrafile

To use more modules, add them to the [Terrafile](https://terraspace.cloud/docs/terrafile/).

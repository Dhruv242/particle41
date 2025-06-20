## Description

- In this Code you find the word "dk" these are the initials of my name.

This architecture allows you to create an EKS (Elastic Kubernetes Service) cluster in AWS with its node group and native VPC CNI configuration for networking.

It also contains the IAM roles needed for both the cluster and the node group.

It accepts incoming traffic from internet through the internet gateway and route it to the subnets.

## Architecture components

Here are all the components of this architecture:
- VPC
- Subnets
- Internet gateway
- Route table and route table associations in every subnet
- IAM roles and policies for both the cluster and the node group
- Security group with its rule(s).

## Requirements

| Name | Configuration |
| --- | --- |
| Terraform | all versions |
| Provider | AWS |
| Provider version | >= 5.33.0 |
| Access | Admin access |

## How to use the architecture

Clone the architecture and modify the following variables according to your needs:

| Variable | Description |
| --- | --- |
| cluster-name | Name of the EKS cluster |
| scaling | Parameters of the scaling, including min and max capacity |
| sg_name | Security group name |
| subnets | Subnets with their configuration |
| NAT | Associated with Private subnet Deployed in Public subnet |
| tags | Tags that are added to all resources |
| vpc_cidr | The CIDR of the VPC |
| workstation-external-cidr | The external IP address that is allowed to access the cluster |

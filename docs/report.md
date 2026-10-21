# MERN Application Deployment using Terraform and Ansible

## Objective
Deploy the TravelMemory MERN application on AWS using Terraform for infrastructure provisioning and Ansible for configuration management.

## Technologies
AWS EC2, VPC, public and private subnets, Internet Gateway, NAT Gateway, security groups, Terraform, Ansible, Ubuntu, Node.js, Express.js, React, MongoDB, Nginx and GitHub.

## Infrastructure
AWS region: us-east-1
VPC CIDR: 10.0.0.0/16
Public subnet: 10.0.1.0/24
Private subnet: 10.0.2.0/24

The application server runs in the public subnet, while the database server runs in the private subnet. Network access is controlled through AWS security groups.

## Application Architecture
Nginx serves the React frontend and proxies API requests to the Express backend on port 3001. The backend connects to MongoDB on the private database server using environment-based configuration.

## Terraform
The terraform directory contains the configuration for AWS networking, security groups, EC2 instances and related infrastructure.

## Ansible
The ansible directory contains the inventory and playbooks for application and database configuration.

The application playbook was executed on the application EC2 instance. The run completed successfully with 4 successful tasks, 0 failed tasks and 0 unreachable hosts. The database playbook is included in the repository, but its execution has not yet been verified.

## Deployment Status
The TravelMemory website was verified at http://44.203.10.48. The Express backend runs as a systemd service. MongoDB is configured on the private database server.

## Evidence
An Ansible application-playbook execution record is stored in docs/evidence/ansible-app-execution.log. The repository also includes a screenshot of the working website.

## Security
The database server is placed in a private subnet. Credentials, private keys, Terraform state files and environment files must not be committed to the public repository.

## Conclusion
This project demonstrates Terraform-based AWS infrastructure provisioning and deployment of a MERN application, with Ansible automation for application-server configuration.

# MERN Application Deployment using Terraform and Ansible

## Objective
Deploy the TravelMemory MERN application on AWS using Terraform for infrastructure provisioning and Ansible for configuration management.

## Technologies
AWS EC2, VPC, subnets, Internet Gateway, NAT Gateway, security groups, Terraform, Ansible, Ubuntu, Node.js, Express.js, React, MongoDB, Nginx and GitHub.

## Infrastructure
The solution uses AWS region us-east-1 and VPC CIDR 10.0.0.0/16.
- Public subnet: 10.0.1.0/24
- Private subnet: 10.0.2.0/24
- Application server: Ubuntu EC2 in the public subnet
- Database server: Ubuntu EC2 in the private subnet
- Internet Gateway and NAT Gateway for network connectivity
- Security groups to restrict SSH and database access

## Application Architecture
Nginx serves the React frontend and proxies API requests to the Express backend on port 3001. The backend connects to MongoDB on the private database server using environment variables.

## Terraform
Terraform files in the terraform directory define the AWS networking, security groups, EC2 instances and outputs.

## Ansible
The ansible directory contains an inventory and playbooks for configuring the application and database servers. Record successful playbook execution after the playbooks have been run and validated.

## Deployment Status
The TravelMemory website is accessible at http://44.203.10.48. The Express backend runs as a systemd service and is enabled to start automatically. MongoDB is configured on the private database server.

## Testing and Evidence
Add screenshots of the working website, Terraform deployment, and Ansible execution results under docs/screenshots.

## Security
The database server is in a private subnet, and database access is restricted through its security group. Credentials and Terraform state files must not be committed to a public repository.

## Conclusion
This project demonstrates AWS infrastructure provisioning with Terraform and MERN application deployment, with Ansible playbooks prepared for configuration automation.

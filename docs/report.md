# MERN Application Deployment Using Terraform and Ansible

## 1. Project Objective

The objective of this project is to deploy a MERN application on AWS using Terraform for infrastructure provisioning and Ansible for configuration management.

## 2. Technology Stack

- AWS EC2
- Terraform
- Ansible
- Ubuntu Linux
- MongoDB
- Express.js and Node.js
- React.js
- Nginx
- Git and GitHub

## 3. Infrastructure Architecture

The AWS infrastructure was provisioned using Terraform in the `us-east-1` region.

The infrastructure includes:

- A Virtual Private Cloud (VPC) with CIDR `10.0.0.0/16`
- A public subnet with CIDR `10.0.1.0/24` for the application server
- A private subnet with CIDR `10.0.2.0/24` for the database server
- An Internet Gateway for public internet connectivity
- A NAT Gateway to support outbound connectivity from the private subnet
- Route tables and security groups
- An EC2 application server and a separate EC2 database server

The application server is publicly accessible, while the database server is placed in the private subnet.

## 4. Application Deployment

The TravelMemory MERN application was deployed on the application EC2 instance.

- React frontend served through Nginx
- Nginx configured to proxy API requests to the Express backend
- Express backend running as the `travelmemory-backend` systemd service on port `3001`
- MongoDB hosted on the private database EC2 instance

Application URL: http://44.203.10.48

## 5. Terraform Implementation

Terraform was used to define and provision the AWS infrastructure, including the VPC, subnets, network routing, security groups, and EC2 instances.

Terraform configuration files are maintained in the `terraform/` directory.

## 6. Ansible Configuration Management

Ansible playbooks were executed from the application server to configure and verify the application and database servers.

### Application server playbook

Playbook: `ansible/playbooks/configure-app.yml`

Tasks:
- Install Nginx if required
- Ensure Nginx is started and enabled
- Ensure the TravelMemory backend service is started and enabled

Execution result:

- Successful playbook execution
- `ok=4`
- `changed=0`
- `unreachable=0`
- `failed=0`

Evidence: `docs/evidence/ansible-app-execution.log`

### Database server playbook

Playbook: `ansible/playbooks/configure-db.yml`

Tasks:
- Ensure MongoDB is installed
- Ensure the MongoDB service is started and enabled

Execution result:

- Successful playbook execution
- `ok=3`
- `changed=0`
- `unreachable=0`
- `failed=0`

Evidence: `docs/evidence/ansible-db-execution.log`

The zero-change results indicate that the required packages and services were already in the desired state when the playbooks were executed.

## 7. Security Considerations

- The database server is located in a private subnet.
- Network access is controlled through AWS security groups.
- Sensitive credentials, private keys, environment files, Terraform state files, and variable files containing secrets must not be committed to the public repository.
- The application and database servers are separated into distinct instances.

## 8. Evidence and Repository

Ansible execution logs are maintained under `docs/evidence/`.

Repository: https://github.com/hitesh-1984-pardeshi/MERN-Terraform-Ansible

## 9. Conclusion

The MERN application was deployed on AWS using Terraform-provisioned infrastructure. The application and database Ansible playbooks both executed successfully, with no failed or unreachable hosts. Execution evidence is included in the repository to support project review and assessment.

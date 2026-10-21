
variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix for project resources"
  type        = string
  default     = "mern-assignment"
}

variable "my_ip_cidr" {
  description = "Your public IPv4 address in CIDR notation, for example 203.0.113.10/32"
  type        = string

  validation {
    condition     = can(cidrhost(var.my_ip_cidr, 0)) && can(regex("/32$", var.my_ip_cidr))
    error_message = "Provide your public IPv4 address with a /32 suffix."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Existing AWS EC2 key pair name"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Local path to the matching SSH private key file"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "Application database username"
  type        = string
  default     = "mernapp"
}

variable "db_password" {
  description = "Application database password"
  type        = string
  sensitive   = true
}

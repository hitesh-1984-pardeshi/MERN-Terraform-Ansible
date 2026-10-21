
# Discover available Availability Zones in the selected region
data "aws_availability_zones" "available" {
  state = "available"
}

# Create the project VPC
resource "aws_vpc" "mern_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "${var.project_name}-vpc"
    Project = var.project_name
  }
}

# Public subnet for the web server
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.mern_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project_name}-public-subnet"
    Project = var.project_name
  }
}

# Private subnet for the database server
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.mern_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name    = "${var.project_name}-private-subnet"
    Project = var.project_name
  }
}

# Internet Gateway for the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mern_vpc.id

  tags = {
    Name    = "${var.project_name}-igw"
    Project = var.project_name
  }
}

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.mern_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "${var.project_name}-public-rt"
    Project = var.project_name
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name    = "${var.project_name}-nat-eip"
    Project = var.project_name
  }
}

# NAT Gateway in the public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name    = "${var.project_name}-nat"
    Project = var.project_name
  }
}

# Private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.mern_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name    = "${var.project_name}-private-rt"
    Project = var.project_name
  }
}

# Associate private subnet with private route table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Security group for the public application server
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-app-sg"
  description = "Allow SSH from my IP and HTTP application traffic"
  vpc_id      = aws_vpc.mern_vpc.id

  ingress {
    description = "SSH from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  ingress {
    description = "HTTP web traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS web traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-app-sg"
    Project = var.project_name
  }
}

# Security group for the private MongoDB server
resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-db-sg"
  description = "Allow MongoDB only from the application server"
  vpc_id      = aws_vpc.mern_vpc.id

  ingress {
    description     = "MongoDB from application server"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-db-sg"
    Project = var.project_name
  }
}

# Find the latest Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Public application server
resource "aws_instance" "app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = 12
    volume_type = "gp3"
  }

  tags = {
    Name    = "${var.project_name}-app-server"
    Project = var.project_name
    Role    = "application"
  }
}

# Private MongoDB server
resource "aws_instance" "db" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  key_name               = var.key_pair_name

  root_block_device {
    volume_size = 12
    volume_type = "gp3"
  }

  tags = {
    Name    = "${var.project_name}-db-server"
    Project = var.project_name
    Role    = "database"
  }
}

# Public IP of the application server
output "app_public_ip" {
  description = "Public IPv4 address of the application server"
  value       = aws_instance.app.public_ip
}

# Private IP of the database server
output "db_private_ip" {
  description = "Private IPv4 address of the database server"
  value       = aws_instance.db.private_ip
}

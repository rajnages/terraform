/*
Backends in Terraform define where and how Terraform's state file is stored.
 They can be local (on your machine) or remote (like AWS S3 or HashiCorp 
 Consul), allowing for better collaboration among team members. 
 Using a remote backend helps keep the state file secure and supports 
 features like state locking and versioning.
*/
# terraform {
#   backend "s3" {
#     bucket = "terraform-sample-one-bucket"
#     key    = "config-file"
#     region = "us-east-1"
#   }
# }

/*
Resources in Terraform are the building blocks used to define and create 
infrastructure components, such as virtual machines, storage, or networks. 
Each resource represents a specific piece of infrastructure that Terraform 
manages, allowing you to create, update, or delete it as needed.
*/
# provider aws
provider "aws" {
  region = var.region_name
}

#resources block of vpc
resource "aws_vpc" "Terraform-vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = var.vpc_tags
  }
}

#resources block IGW
resource "aws_internet_gateway" "Terraform_IGW" {
  vpc_id = aws_vpc.Terraform-vpc.id
  tags = {
    Name = var.igw_tag
  }
}

#resources block subnet
resource "aws_subnet" "Public_terraform_subnet" {
  vpc_id     = aws_vpc.Terraform-vpc.id
  cidr_block = var.subnet_cidr
  availability_zone = var.azs

  tags = {
    Name = var.subnet_tag
  }
}

#resources block subnet
resource "aws_subnet" "Private_terraform_subnet" {
  vpc_id     = aws_vpc.Terraform-vpc.id
  cidr_block = var.private_cidr
  availability_zone = var.azs

  tags = {
    Name = var.subnet_tag
  }
}

#resouces block for route table

resource "aws_route_table" "Terraform_routetable" {
  vpc_id = aws_vpc.Terraform-vpc.id

  route {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.Terraform_IGW.id
  }

  #   route {
  #     ipv6_cidr_block        = "::/0"
  #     egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  #   }

  tags = {
    Name = var.route_table_tag
  }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.Public_terraform_subnet.id
  route_table_id = aws_route_table.Terraform_routetable.id
}

resource "aws_security_group" "Terraform-security" {
  name   = var.security_group_name  # Add a name for the security group
  vpc_id = aws_vpc.Terraform-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.security_cidr  # Specify the CIDR block or use a specific IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all traffic
    cidr_blocks = var.security_cidr
  }

  tags = {
    Name = var.security_group_name
  }
}

          
           
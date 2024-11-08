provider "aws" {
    region = "eu-west-1"
}
variable "subnet_cidr_block" {
  description = "subnet cidr block"
  }
  
  variable "vpc_cidr_block" {
    description = "vpc cidr block"
    
  }

  variable "avail_zone" {
   description = "availability zone"
  }

  variable "env_prefix" {
    description = "environment"
  }

  variable "my_ip" {
    
  }
resource "aws_vpc" "Ireland-Prod-VPC" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-VPC"
    Owner = "Nick"
    Service = "Production"
  } 
} 
resource "aws_subnet" "VPC-A-Prod" {
 vpc_id = aws_vpc.Ireland-Prod-VPC.id 
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone 
  tags = { 
    Name = "${var.env_prefix}-subnet-1"
    Owner = "Nick"
    Service = "Production"
  }
}

output "dev-vpc-id" {
  value = aws_vpc.Ireland-Prod-VPC.id
  
}

output "dev-subnet-id" {
  value = aws_subnet.VPC-A-Prod.id
}

resource "aws_internet_gateway" "IrelandProd-igw" {
    vpc_id = aws_vpc.Ireland-Prod-VPC.id
  tags = {
  Name = "${var.env_prefix}-igw" 
  }
}


resource "aws_default_route_table" "default-rtb" {
  default_route_table_id = aws_vpc.Ireland-Prod-VPC.default_route_table_id

    route { 
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IrelandProd-igw.id

  }
  tags = {
    Name = "${var.env_prefix}main-rtb"
  }
}

resource "aws_security_group" "IrelandProd-SG" {
  name = "IrelandProd-SG"
  vpc_id = aws_vpc.Ireland-Prod-VPC.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = [var.my_ip]

  }

  ingress {
     from_port = 8080
    to_port = 8080
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
     from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
tags = {
  Name = "${var.env_prefix}-sg"
  }
}
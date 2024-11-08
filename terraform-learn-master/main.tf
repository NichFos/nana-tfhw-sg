provider "aws" {
    region = "eu-west-1"
}
variable "subnet_cidr_block" {
  description = "subnet cidr block"
  }
  
resource "aws_vpc" "Ireland-Prod-VPC" {
  cidr_block = "10.80.0.0/16"
  tags = {
    Name = "Ireland-Prod-VPC"
    Owner = "Nick"
    Service = "Production"
  } 
} 
resource "aws_subnet" "VPC-A-Prod" {
 vpc_id = aws_vpc.Ireland-Prod-VPC.id 
  cidr_block = var.subnet_cidr_block
  availability_zone = "eu-west-1a" 
  tags = { 
    Name = "VPC-A-Prod"
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
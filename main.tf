#create a vpc
resource "aws_vpc" "test_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

#create an internet gateway and attach it to the test_vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "${var.name}-igw"
  }
}

#create a route table for the internet traffic
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.test_vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name}-public-route-table"
  }
}

#create a public subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.name}-public-subnet"
  }
}

#Associate route table with the public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_route.id
}

#create ec2 instance 
resource "aws_instance" "test_server" {
  ami                         = var.os
  instance_type               = var.instance_type
  key_name                    = "ec2_key"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.test_server_sg.id]

  tags = {
    Name = "${var.name}-ec2"
  }
}

# Create the security group
resource "aws_security_group" "test_server_sg" {
  name        = "test_server_sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.test_vpc.id

  dynamic "ingress" {
    for_each = local.ingress_rule

    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }
}

#create a key pair for the server
resource "aws_key_pair" "test_keypair" {
  key_name   = "ec2_key"
  public_key = var.public_key

  tags = {
    Environment = var.name
  }
}

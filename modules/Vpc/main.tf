resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = true
  
}
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

data "aws_availability_zones" "availability_zones" {
  
}
resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_1_cidr
  availability_zone = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public_subnet_1"
  }
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_2_cidr
  availability_zone = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch = true

    tags = {
    "Name" = "public_subnet_2"
  }
}
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  
}
resource "aws_route_table_association" "route_table_association_1" {
    subnet_id = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.route_table.id

}
resource "aws_route_table_association" "route_table_association_2" {
    subnet_id = aws_subnet.public_subnet_2.id
    route_table_id = aws_route_table.route_table.id

}
resource "aws_subnet" "private_subnet_1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_1_cidr
  availability_zone = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch = false

        tags = {
    "Name" = "private_subnet_1"
  }
}
resource "aws_subnet" "private_subnet_2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_2_cidr
  availability_zone = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch = false

          tags = {
    "Name" = "private_subnet_2"
  }
}
resource "aws_subnet" "database_subnet_1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.database_subnet_1_cidr
  availability_zone = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch = false

          tags = {
    "Name" = "database_subnet_1"
}
}
resource "aws_subnet" "database_subnet_2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.database_subnet_2_cidr
  availability_zone = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch = false

          tags = {
    "Name" = "database_subnet_2"
}
}

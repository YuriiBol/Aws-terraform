resource "aws_eip" "eip_1" {
  vpc = true
}

resource "aws_eip" "eip_2" {
  vpc = true
}
resource "aws_nat_gateway" "nat_geteway_1" {
 allocation_id = aws_eip.eip_1.id
 subnet_id = var.public_subnet_1_id

 tags = {
   "Name" = "nat_geteway_1"
 }
}
resource "aws_nat_gateway" "nat_geteway_2" {
 allocation_id = aws_eip.eip_2.id
 subnet_id = var.public_subnet_2_id

  tags = {
   "Name" = "nat_geteway_2"
 }
}        

resource "aws_route_table" "private_table_1" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_geteway_1.id
    }
      tags = {
   "Name" = "route_table_nat"
 }
  
}        

resource "aws_route_table_association" "private_subnet1_association" {
  subnet_id = var.private_subnet_1_id
  route_table_id = aws_route_table.private_table_1.id
}
resource "aws_route_table_association" "database_subnet1_association" {
  subnet_id = var.database_subnet_1_id
  route_table_id = aws_route_table.private_table_1.id
}

resource "aws_route_table" "private_table_2" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_geteway_2.id
    }
      tags = {
   "Name" = "route_table_nat"
 }
  
}        
resource "aws_route_table_association" "private_subnet2_association" {
  subnet_id = var.private_subnet_2_id
  route_table_id = aws_route_table.private_table_2.id
}
resource "aws_route_table_association" "database_subnet2_association" {
  subnet_id = var.database_subnet_2_id
  route_table_id = aws_route_table.private_table_2.id
}
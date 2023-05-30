resource "aws_security_group" "alb_security_group" {
  name           = "${var.environment}-alb-sg"
  description    = "enable hhtp/https"
  vpc_id = var.vpc_id

  ingress {
    description = "http_access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  ingress {
    description = "https_access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "${var.environment}-alb-sg"
  }

}

resource "aws_security_group" "bastion_host_security_group" {
  name = "${var.environment}-bastion-sg"
  description    = "enable ssh"
  vpc_id = var.vpc_id


  ingress {
    description = "ssh-acess"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_location]
  } 
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
    name = "${var.environment}-bastion-sg"
  }
}
resource "aws_security_group" "appserver_security_group" {
  name           = "${var.environment}-appserver-sg"
  description    = "enable hhtp/https via alb-sg"
  vpc_id = var.vpc_id
 
  ingress {
    description = "http_access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  } 
  ingress {
    description = "https_access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  } 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "${var.environment}-appserver-sg"
  }
  depends_on = [
    aws_security_group.alb_security_group
  ]

}
resource "aws_security_group" "database_security_group" {
  name           = "${var.environment}-database-sg"
  description    = "enable database 3306"
  vpc_id = var.vpc_id
 
  ingress {
    description = "http_access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.appserver_security_group.id]
  } 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "${var.environment}-database-sg"
  }
  depends_on = [
    aws_security_group.appserver_security_group
  ]

}


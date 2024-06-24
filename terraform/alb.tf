## --------- ALB ----------
resource "aws_security_group" "alb_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "${terraform.workspace}-alb-SG"
  description = "Security Group of AWS ALB"
  tags = {
    Name      = "${terraform.workspace}-alb-SG"
    Terraform = "true"
  }
  ingress {
    description = "Allow all Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [module.vpc]
}


# aws_lb:
resource "aws_lb" "alb" {
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  internal           = false
  name               = "${local.env.environment}-alb"
  security_groups = [
    aws_security_group.alb_sg.id
  ]
  subnets = [
    module.vpc.public_subnets[0],
    module.vpc.public_subnets[1]
  ]
  tags = {
    Terraform = "true"
    Name      = "${local.env.environment}-alb"
  }

  depends_on = [aws_security_group.alb_sg]
}
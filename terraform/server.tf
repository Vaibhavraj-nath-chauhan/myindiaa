// Instance server security group
resource "aws_security_group" "instance" {
  vpc_id      = module.vpc.vpc_id
  name        = "${local.env.environment}-instance"
  description = "Server security group"
  tags = {
    Name      = "${local.env.environment}-instance"
    Terraform = "true"
  }
  // Allow SSH access from trusted IP
  ingress {
    description = "Allow SSH access from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  // Allow all traffic from this server to other servers
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  depends_on = [aws_lb.alb]
}


resource "aws_key_pair" "instance" {
  key_name   = "${local.env.environment}-instance-key"
  public_key = file("key/${terraform.workspace}/server.pub")

  depends_on = [aws_security_group.instance]
}


# Instace 1
resource "aws_instance" "instance_1" {
  ami                    = local.env.server_ami
  instance_type          = local.env.server_instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = aws_key_pair.instance.key_name
  subnet_id              = module.vpc.private_subnets[0]

  user_data = <<-EOF
              #!/bin/bash
              # Update package list
              sudo apt-get update

              # Install Docker
              sudo apt-get install -y docker.io

              # Start Docker service
              sudo systemctl start docker
              sudo systemctl enable docker

              # Add ubuntu user to docker group
              sudo usermod -aG docker ubuntu

              EOF

  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_size           = local.env.server_volume
    volume_type           = "gp2"
    delete_on_termination = true
    tags = {
      Terraform   = "true"
      Environment = "${local.env.environment}"
      Name        = "${local.env.environment}-instance-1"
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "${local.env.environment}"
    Name        = "${local.env.environment}-instance-1"
  }

  depends_on = [aws_key_pair.instance]
}
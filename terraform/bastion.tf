// Bastion server security group
resource "aws_security_group" "bastion" {
  vpc_id      = module.vpc.vpc_id
  name        = "${local.env.environment}-bastion"
  description = "Bastion-server security group"
  tags = {
    Name      = "${local.env.environment}-bastion"
    Terraform = "true"
  }
  // Allow SSH access from trusted IP
  ingress {
    description = "Trusted IP for SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.175.100.120/32"]
  }

  ingress {
    description = "Allow SSH access from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  // Allow all traffic from bastion server to other servers
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  depends_on = [ module.vpc ]
}


resource "aws_key_pair" "bastion" {
  key_name   = "${local.env.environment}-bastion-key"
  public_key = file("key/${terraform.workspace}/bastion.pub")

  depends_on = [aws_security_group.bastion]
}


#Bastion server
resource "aws_instance" "bastion" {
  ami                         = local.env.bastion_ami
  instance_type               = local.env.bastion_instance_type
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = aws_key_pair.bastion.key_name
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_size           = local.env.bastion_volume
    volume_type           = "gp2"
    delete_on_termination = true
    tags = {
      Terraform   = "true"
      Environment = "${local.env.environment}"
      Name        = "${local.env.environment}-bastion"
      type        = "Bation Server"
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "${local.env.environment}"
    Name        = "${local.env.environment}-bastion"
  }

  depends_on = [aws_key_pair.bastion]
}
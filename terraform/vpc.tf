module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.env.environment}-vpc"
  cidr = local.env.cidr

  azs              = local.env.azs
  private_subnets  = local.env.private_subnets
  public_subnets   = local.env.public_subnets
  database_subnets = local.env.database_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  enable_vpn_gateway     = false
  one_nat_gateway_per_az = false

  tags = {
    Terraform   = "true"
    Environment = "${local.env.environment}-vpc"
  }
}
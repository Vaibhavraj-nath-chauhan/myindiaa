output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets

}

# Bastion
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}


# # Instance 1
# output "instance_1_private_ip" {
#   value = aws_instance.instance_1.private_ip
# }

# # Instance 2
# output "instance_2_private_ip" {
#   value = aws_instance.instance_2.private_ip
# }

# # Instance 3
# output "instance_3_private_ip" {
#   value = aws_instance.instance_3.private_ip

# }

# ## RDS
# output "rds_endpoint" {
#   value = aws_db_instance.rds.endpoint

# }

locals {

  dev = {
    profile     = "myindiaa"
    region      = "us-west-2"
    environment = "dev"

    #vpc
    cidr             = "10.50.0.0/20"
    azs              = ["us-west-2a", "us-west-2b"]
    public_subnets   = ["10.50.1.0/24", "10.50.2.0/24"]
    private_subnets  = ["10.50.5.0/24", "10.50.6.0/24"]
    database_subnets = ["10.50.11.0/24", "10.50.12.0/24"]

    # Bastion Server
    bastion_ami           = "ami-0cf2b4e024cdb6960"
    bastion_instance_type = "t3.micro"
    bastion_volume        = 8

    # Backend Server
    server_ami           = "ami-0cf2b4e024cdb6960"
    server_instance_type = "t3.micro"
    server_volume        = 20
  }

  #   staging = {
  #   }

  #   prod = {
  #   }

  env = terraform.workspace == "dev" ? local.dev : null
  //local.dev : terraform.workspace == "prod" ? local.prod : terraform.workspace == "staging" ? local.staging : null
}
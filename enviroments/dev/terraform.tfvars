###############################################################
# Variables Globales
###############################################################
#
aws_region="us-east-1"

#
profile="pra_idp_dev"

#
environment = "dev"

#
client = "pragma"

#
project = "fc"

#
common_tags = {
  environment   = "dev"
  project-name  = "Modulos Referencia"
  cost-center   = "-"
  owner         = "cristian.noguera@pragma.com.co"
  area          = "KCCC"
  provisioned   = "terraform"
  datatype      = "interno"
}

###############################################################
# Variables Definicion VPC
###############################################################
cidr_block                 = "10.60.0.0/22"   # Variable
instance_tenancy           = "default"        # Fijo
enable_dns_support         = true             # Fijo
enable_dns_hostnames       = true # Fijo
flow_log_retention_in_days = 60 # Variable
create_igw = true # Fijo
create_nat = true # Fijo

subnet_config = {
  public = {
    public      = true # Fijo
    include_nat = false # Fijo
    subnets = [
      {
        cidr_block        = "10.60.0.0/26" # Variable
        availability_zone = "a" # Variable
      },
      {
        cidr_block        = "10.60.0.64/26" # Variable
        availability_zone = "b" # Variable
      }
    ]
    custom_routes = [
    ]
  }
  private = {
    public      = false
    include_nat = true
    subnets = [
      {
        cidr_block        = "10.60.0.128/26"
        availability_zone = "a"
      },
      {
        cidr_block        = "10.60.0.192/26"
        availability_zone = "b"
      }
    ]
    custom_routes = [
    ]
  }
  service = {
    public      = false
    include_nat = true
    subnets = [
      {
        cidr_block        = "10.60.1.0/26"
        availability_zone = "a"
      },
      {
        cidr_block        = "10.60.1.64/26"
        availability_zone = "b"
      }
    ]
    custom_routes = [
    ]
  }
  database = {
    public      = false
    include_nat = false
    subnets = [
      {
        cidr_block        = "10.60.1.128/26"
        availability_zone = "a"
      },
      {
        cidr_block        = "10.60.1.192/26"
        availability_zone = "b"
      }
    ]
    custom_routes = [
    ]
  }
}
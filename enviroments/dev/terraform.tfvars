###########################################
########## Common variables ###############
###########################################

profile     = "profile01"
aws_region  = "us-east-1"
environment = "dev"
client      = "cliente01"
project     = "proyecto01"
common_tags = {
  environment   = "dev"
  project-name  = "proyecto01"
  cost-center   = "xxx"
  owner         = "xxx"
  area          = "xxx"
  provisioned   = "xxx"
  datatype      = "xxx"
}

###########################################
############ VPC variables ################
###########################################

cidr_block                 = "10.60.0.0/22"   
instance_tenancy           = "default"        
enable_dns_support         = true             
enable_dns_hostnames       = true 

###########################################
############### IGW variables #############
###########################################

create_igw = true

###########################################
############### NAT variables #############
###########################################

create_nat = true

###########################################
############# Subnet variables ############
###########################################

subnet_config = {
  public = {
    public      = true
    include_nat = false
    subnets = [
      {
        cidr_block        = "10.60.0.0/26"
        availability_zone = "a"
      },
      {
        cidr_block        = "10.60.0.64/26"
        availability_zone = "b"
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

###########################################
########### Flow logs variables ###########
###########################################

flow_log_retention_in_days = 60

###########################################
######## VPC Endpoint variables ###########
###########################################

enable_dynamodb_endpoint = true
enable_s3_endpoint = true
enable_sm_endpoint = true
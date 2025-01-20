###########################################
########## Common variables ###############
###########################################

variable "profile" {
  type = string
  description = "Profile name containing the access credentials to deploy the infrastructure on AWS"
}

variable "common_tags" {
    type = map(string)
    description = "Common tags to be applied to the resources"
}

variable "aws_region" {
  type = string
  description = "AWS region where resources will be deployed"
}

variable "environment" {
  type = string
  description = "Environment where resources will be deployed"
}

variable "client" {
  type = string
  description = "Client name"
}

variable "project" {
  type = string  
    description = "Project name"
}

#--------------- VPC Module ---------------

###########################################
############ VPC variables ################
###########################################
variable "cidr_block" {
  type = string
  description = "The IPv4 CIDR block for the VPC"
  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "Must be valid CIDR"
  }
}

variable "instance_tenancy" {
  type = string
  description = "A tenancy option for instances launched into the VPC"
  default = "default"
  validation {
    condition     = can(regex("^(default|dedicated)$", var.instance_tenancy))
    error_message = "Invalid tenancy, must be default or dedicated"
  }
}

variable "enable_dns_hostnames" {
  type = bool
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  default = true
}

variable "enable_dns_support" {
  type = bool
  description = "A boolean flag to enable/disable DNS support in the VPC"
  default = true
}

###########################################
############### IGW variables #############
###########################################

variable "create_igw" {
  type = bool
  description = "A boolean flag to enable internet gateway creation"
  default = true
}

###########################################
############### NAT variables #############
###########################################

variable "create_nat" {
  type = bool
  description = "A boolean flag to enable nat gateway creation"
  default = true
}

###########################################
############# subnet variables ############
###########################################

variable "subnet_config" {
  type = map(object({
    custom_routes = list(object({
      destination_cidr_block    = string
      carrier_gateway_id        = optional(string)
      core_network_arn          = optional(string)
      egress_only_gateway_id    = optional(string)
      nat_gateway_id            = optional(string)
      local_gateway_id          = optional(string)
      network_interface_id      = optional(string)
      transit_gateway_id        = optional(string)
      vpc_endpoint_id           = optional(string)
      vpc_peering_connection_id = optional(string)
    }))
    public = bool
    include_nat = optional(bool, false)
    subnets = list(object({
      cidr_block        = string
      availability_zone = string
    }))
  }))
  description = <<EOF
    Custom subnet and route configuration. It is a map where each key represents a group of subnets (e.g. 'public', 'private') and the value is an object with the following structure:
    - custom_routes: (list) A list of objects, each representing a custom route with the following properties:
      - destination_cidr_block: (string) The destination CIDR block for the route.
      - carrier_gateway_id: (string, optional) Identifier of a carrier gateway. This attribute can only be used when the VPC contains a subnet which is associated with a Wavelength Zone.
      - core_network_arn: (string, optional) The Amazon Resource Name (ARN) of a core network.
      - egress_only_gateway_id: (string, optional) Identifier of a VPC Egress Only Internet Gateway.
      - nat_gateway_id: (string, optional) Identifier of a VPC NAT gateway.
      - local_gateway_id: (string, optional) Identifier of a Outpost local gateway.
      - network_interface_id: (string, optional) Identifier of an EC2 network interface.
      - transit_gateway_id: (string, optional) Identifier of an EC2 Transit Gateway.
      - vpc_endpoint_id: (string, optional) Identifier of a VPC Endpoint.
      - vpc_peering_connection_id: (string, optional) Identifier of a VPC peering connection.
    - public: (bool) If true, set 0.0.0.0/0 to igw.
    - include_nat: (bool, optional) If true, set 0.0.0.0/0 to nat.
    - subnets: (list) A list of objects, each representing a subnet with the following properties:
      - cidr_block: (string) The IPv4 CIDR block for the subnet.
      - availability_zone: (string) AZ for the subnet.
  EOF
}

###########################################
############ flow log variables ###########
###########################################

variable "flow_log_retention_in_days" {
  type = number
  validation {
    condition     = can(regex("^[0-9]*$", var.flow_log_retention_in_days))
    error_message = "Must be a number"
  }
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire"
}

#---------- VPC Endpoint Module -----------

###########################################
####### VPC Endpoint variables ############
###########################################

variable "enable_dynamodb_endpoint" {
  type = bool
  description = "A boolean flag to enable/disable dynamodb vpc endpoint creation"
  default = true
}

variable "enable_s3_endpoint" {
  type = bool
  description = "A boolean flag to enable/disable s3 vpc endpoint creation"
  default = true
}

variable "enable_sm_endpoint" {
  type = bool
  description = "A boolean flag to enable/disable sm vpc endpoint creation"
  default = true
}
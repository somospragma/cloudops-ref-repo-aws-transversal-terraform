##################################################
# Variable Globales
##################################################
#
variable "client" {
  type = string
}

#
variable "environment" {
  type = string
}

#
variable "aws_region" {
  type = string
}

#
variable "profile" {
  type = string
}

#
variable "common_tags" {
    type = map(string)
    description = "Tags comunes aplicadas a los recursos"
}

#
variable "project" {
  type = string  
}

##################################################
# Variable Module VPC
##################################################

variable "cidr_block" {
  type = string
}

variable "instance_tenancy" {
  type = string
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "enable_dns_support" {
  type = bool
}

variable "flow_log_retention_in_days" {
  type = number
}

variable "create_igw" {
  type = bool
}

variable "create_nat" {
  type = bool
}

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
}
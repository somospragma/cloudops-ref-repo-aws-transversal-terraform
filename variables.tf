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

#--------- Security Group Module ----------

###########################################
####### Security Group variables ##########
###########################################

variable "sg_config" {
  type = list(object({
    description = string
    vpc_id      = string
    application = string
    ingress = list(object({
      from_port   = string
      to_port     = string
      protocol    = string
      cidr_blocks = list(string)
      prefix_list_ids = list(string)
      security_groups = list(string)
      self = bool
      description = string
    }))
    egress = list(object({
      from_port   = string
      to_port     = string
      protocol    = string
      prefix_list_ids = list(string)
      cidr_blocks = list(string)
      description = string
    }))
  }))
  description = <<EOF
    - description: (string) Security group description. Defaults to Managed by Terraform. Cannot be "". NOTE: This field maps to the AWS GroupDescription attribute, for which there is no Update API. If you'd like to classify your security groups in a way that can be updated, use tags.
    - vpc_id: (string) VPC ID. Defaults to the region's default VPC.
    - application: (string) Application name in order to name security group.
    - ingress:
      - description: (string) Description of this ingress rule.
      - from_port: (string) Start port (or ICMP type number if protocol is icmp or icmpv6).
      - to_port: (string) End range port (or ICMP code if protocol is icmp).
      - protocol: (string) Protocol. If you select a protocol of -1 (semantically equivalent to all, which is not a valid value here), you must specify a from_port and to_port equal to 0. The supported values are defined in the IpProtocol argument on the IpPermission API reference. This argument is normalized to a lowercase value to match the AWS API requirement when using with Terraform 0.12.x and above, please make sure that the value of the protocol is specified as lowercase when using with older version of Terraform to avoid an issue during upgrade.
      - prefix_list_ids: (list(string)) List of Prefix List IDs.
      - cidr_blocks: (list(string)) List of CIDR blocks.
      - security_groups: (list(string)) List of security groups. A group name can be used relative to the default VPC. Otherwise, group ID.
      - self: (bool) Whether the security group itself will be added as a source to this ingress rule.
    - egress:
      - description: (string) Description of this egress rule.
      - from_port: (string) Start port (or ICMP type number if protocol is icmp)
      - to_port: (string) End range port (or ICMP code if protocol is icmp).
      - protocol: (string) Protocol. If you select a protocol of -1 (semantically equivalent to all, which is not a valid value here), you must specify a from_port and to_port equal to 0. The supported values are defined in the IpProtocol argument in the IpPermission API reference. This argument is normalized to a lowercase value to match the AWS API requirement when using Terraform 0.12.x and above. Please make sure that the value of the protocol is specified as lowercase when used with older version of Terraform to avoid issues during upgrade.
      - prefix_list_ids: (list(string)) List of Prefix List IDs.
      - cidr_blocks: (list(string)) List of CIDR blocks.
  EOF
}

#---------- VPC Endpoint Module -----------

###########################################
####### VPC Endpoint variables ############
###########################################

variable "endpoint_config" {
  type = list(object({
    enable = optional(bool, true)
    vpc_id = string
    service_name = string
    vpc_endpoint_type = string
    private_dns_enabled = bool
    security_group_ids = list(string)
    subnet_ids = list(string)
    route_table_ids = list(string)
    application = string
  }))
  description = <<EOF
    - enable: (boolean, optional) The flag indicates if a vpce will be created or not.
    - vpc_id: (string) The ID of the VPC in which the endpoint will be used.
    - service_name: (string) The service name. For AWS services the service name is usually in the form com.amazonaws.<region>.<service>
    - vpc_endpoint_type: (string) The VPC endpoint type, Gateway, GatewayLoadBalancer, or Interface. Defaults to Gateway.
    - private_dns_enabled: (bool) AWS services and AWS Marketplace partner services only. Whether or not to associate a private hosted zone with the specified VPC. Applicable for endpoints of type Interface. Most users will want this enabled to allow services within the VPC to automatically use the endpoint. Defaults to false.
    - security_group_ids: (list(string)) The ID of one or more security groups to associate with the network interface. Applicable for endpoints of type Interface. If no security groups are specified, the VPC's default security group is associated with the endpoint.
    - subnet_ids: (list(string)) The ID of one or more subnets in which to create a network interface for the endpoint. Applicable for endpoints of type GatewayLoadBalancer and Interface. Interface type endpoints cannot function without being assigned to a subnet.
    - route_table_ids: (list(string)) One or more route table IDs. Applicable for endpoints of type Gateway.
    - application: (string) Application name in order to name vpc-endpoint
  EOF
}

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
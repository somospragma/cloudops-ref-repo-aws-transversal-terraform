###########################################
############## VPC Module #################
###########################################

module "vpc" {
  #Before using the module, once you have the new location of your repo, you need to change the source value.
  source = "git::https://github.com/somospragma/cloudops-ref-repo-aws-vpc-terraform.git?ref=main"
  providers = {
    aws.project = aws.pra_idp_dev
  }
  client      = var.client
  project     = var.project
  environment = var.environment
  aws_region  = var.aws_region

  cidr_block                 = var.cidr_block
  instance_tenancy           = var.instance_tenancy
  enable_dns_support         = var.enable_dns_support
  enable_dns_hostnames       = var.enable_dns_hostnames
  flow_log_retention_in_days = var.flow_log_retention_in_days

  subnet_config = var.subnet_config

  create_igw = var.create_igw
  create_nat = var.create_nat
}

###########################################
######### Security Group Module ###########
###########################################

module "security_groups" {
  #Before using the module, once you have the new location of your repo, you need to change the source value.
  source = "git::https://github.com/somospragma/cloudops-ref-repo-aws-sg-terraform.git?ref=feature/sg-module-init"
  providers = {
    aws.project = aws.pra_idp_dev
  }
  client      = var.client
  project     = var.project
  environment = var.environment

  sg_config = [
    {
      application = "sm"
      description = "Security group for VPC Endpoint"
      vpc_id      = module.vpc.vpc_id

      ingress = [
        {
          from_port       = 443
          to_port         = 443
          protocol        = "tcp"
          cidr_blocks     = ["0.0.0.0/0"]
          security_groups = []
          prefix_list_ids = []
          self            = false
          description     = "Allow HTTPS inbound"
        }
      ]

      egress = [
        {
          from_port       = 0
          to_port         = 0
          protocol        = "-1"
          cidr_blocks     = ["0.0.0.0/0"]
          prefix_list_ids = []
          description     = "Allow all outbound traffic"
        }
      ]
    }
  ]
  depends_on = [module.vpc]
}

###########################################
########## VPC Endpoint Module ############
###########################################

module "vpc_endpoints" {
  #Before using the module, once you have the new location of your repo, you need to change the source value.
  source = "git::https://github.com/somospragma/cloudops-ref-repo-aws-vpc-endpoint-terraform.git?ref=feature/vpce-module-init"
  providers = {
    aws.project = aws.pra_idp_dev
  }
  client      = var.client
  environment = var.environment
  project     = var.project

  endpoint_config = [
    # DynamoDB Endpoint (Gateway type)
    {
      enable              = var.enable_dynamodb_endpoint
      vpc_id              = module.vpc.vpc_id
      service_name        = "com.amazonaws.us-east-1.dynamodb"
      vpc_endpoint_type   = "Gateway"
      private_dns_enabled = false
      security_group_ids  = []
      subnet_ids          = []
      route_table_ids     = [module.vpc.route_table_ids["private"], module.vpc.route_table_ids["service"], module.vpc.route_table_ids["database"]]
      application         = "dynamodb"
    },
    # S3 Endpoint (Gateway type)
    {
      enable              = var.enable_s3_endpoint
      vpc_id              = module.vpc.vpc_id
      service_name        = "com.amazonaws.us-east-1.s3"
      vpc_endpoint_type   = "Gateway"
      private_dns_enabled = false
      security_group_ids  = []
      subnet_ids          = []
      route_table_ids     = [module.vpc.route_table_ids["private"], module.vpc.route_table_ids["service"], module.vpc.route_table_ids["database"]]
      application         = "s3"
    },
    # SM Endpoint (Interface type)
    {
      enable              = var.enable_sm_endpoint
      vpc_id              = module.vpc.vpc_id
      service_name        = "com.amazonaws.us-east-1.secretsmanager"
      vpc_endpoint_type   = "Interface"
      private_dns_enabled = true
      security_group_ids  = [module.security_groups.sg_info["sm"].sg_id]
      subnet_ids          = [module.vpc.subnet_ids["private-0"], module.vpc.subnet_ids["private-1"], ]
      route_table_ids     = []
      application         = "sm"
    }
  ]
  depends_on = [module.security_groups, module.vpc]
}

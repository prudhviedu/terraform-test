provider "aws" {
  region = "${local.region}"
}
## TODO - update region to 'us-gov-west-1' ##
terraform {
  backend "s3" {
    bucket         = "mel-terraform-remote-state-prod"
    key            = "terraform.tfstate.mel-prod-vpc"
    dynamodb_table = "mel-terraform-lock-prod"
    region         = "us-east-1"
    encrypt        = true
  }
}
## TODO - update region to 'us-gov-west-1' ##
data terraform_remote_state "mel-global" {
  backend = "s3" 
  config = {
    bucket         = "mel-terraform-remote-state-global"
    key            = "terraform.tfstate.mel-global"
    dynamodb_table = "mel-terraform-lock-global"
    region         = "us-east-1"
    encrypt        = true
  }
}
## TODO - update region to 'us-gov-west-1' ##
data terraform_remote_state "mel-prod" {
  backend = "s3" 
  config = {
    bucket         = "mel-terraform-remote-state-prod"
    key            = "terraform.tfstate.mel-prod"
    dynamodb_table = "mel-terraform-lock-prod"
    region         = "us-east-1"
    encrypt        = true
  }
}
resource "aws_vpc_dhcp_options" "custom-dhcp-options" {
  ## TODO - update region to 'us-gov-west-1' ##
  domain_name = "ec2.internal"
  domain_name_servers = [
    "AmazonProvidedDNS"
    ]

    ### for use later ### 
    # ntp_servers = [
    # "ip_of_NTP_server"
    # ]

    # netbios_name_servers = [
    # "ip_of_netbios_server"
    # ]

    # netbios_node_type = 2
    ####################

    # tags = "${merge(local.prod_base_tags, var.dhcp_options_tags)}"

    tags = "${merge(
            "${map(
                "Name", "${local.vpc}-dhcp-options-set"
            )}",
            "${local.pvpc_base_tags}"
  )}"
}

module "base" {
  source = "../../../modules/vpc"

  base_tags = "${local.pvpc_base_tags}"
  vpc = "${local.vpc}"
  cidr_block     = "${var.cidr_block}"
  ## TODO - uncomment to establish VPN resources ##
  # gateway_1_address = "${var.gateway_1_address}"
  # gateway_2_address = "${var.gateway_2_address}"
  # bgp_asn           = "${var.bgp_asn}"
  # csr_1_tunnel_1_inside_cidr = "${var.csr_1_tunnel_1_inside_cidr}"
  # csr_1_tunnel_2_inside_cidr = "${var.csr_1_tunnel_2_inside_cidr}"
  # csr_2_tunnel_1_inside_cidr = "${var.csr_2_tunnel_1_inside_cidr}"
  # csr_2_tunnel_2_inside_cidr = "${var.csr_2_tunnel_2_inside_cidr}"
  custom_dhcp_options_id = "${aws_vpc_dhcp_options.custom-dhcp-options.id}"
}
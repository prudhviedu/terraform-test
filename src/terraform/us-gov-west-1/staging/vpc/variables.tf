## TODO - update to corerct VPC CIDR once we have it ##
variable "cidr_block" {
    default = ""
}
## TODO - uncomment and populate to establish VPN resources ##
# variable "gateway_1_address" {
#     default = ""
# }
# variable "gateway_2_address" {
#     default = ""
# }
# variable "csr_1_tunnel_1_inside_cidr" {
#     default = ""
# }
# variable "csr_1_tunnel_2_inside_cidr" {
#     default = ""
# }
# variable "csr_2_tunnel_1_inside_cidr" {
#     default = ""
# }
# variable "csr_2_tunnel_2_inside_cidr" {
#     default = ""
# }
# variable "bgp_asn" {
#     default = ""
# }
locals {
    region = "${data.terraform_remote_state.mel-global.region}"
    vpc = "${data.terraform_remote_state.mel-stage.vpc}"
    stage_base_tags = "${data.terraform_remote_state.mel-stage.svpc_base_tags}"
}



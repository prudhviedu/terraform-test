variable "vpc" {
  default = "dvpc"
}
variable "Environment" {
  default = "Dev"
}
# TODO -- add VPC ID once we have
variable "vpc-id" {
  default = "vpc-011169f21c2ac2922"
}
# TODO -- add VPC CIDR once we have
variable "vpc-cidr" {
  default = "10.247.100.0/22"
}
locals {
  region = "${data.terraform_remote_state.mel-global.region}"
  base_tags = "${data.terraform_remote_state.mel-global.base_tags}"
}
variable "vpc" {
  default = "svpc"
}
variable "Environment" {
  default = "Stage"
}
# TODO -- add VPC ID once we have
variable "vpc-id" {
  default = ""
}
# TODO -- add VPC CIDR once we have
variable "vpc-cidr" {
  default = ""
}
locals {
  region = "${data.terraform_remote_state.mel-global.region}"
  base_tags = "${data.terraform_remote_state.mel-global.base_tags}"
}
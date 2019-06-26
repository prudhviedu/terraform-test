# Instance type for Jenkins server
# TODO -- update with correct instance type
variable "instance_type" {
  default = "t2.micro"
}
variable "key_name" {
    default = "dev-shared-key"
}
variable "subnet_id" {
    default = "subnet-0f47f5f39e5d3255c"
}
# TODO --update-- Availabiblty Zone Jenkins server will live in
variable "availability_zones" {
    default = "us-east-1a"
}
 variable "private_ip" {
     default = ""
 }

 locals {
     region = "${data.terraform_remote_state.mel-global.region}"
     ami = "${data.terraform_remote_state.mel-global.latest_amazon_linux_2}"
     vpc = "${data.terraform_remote_state.mel-dev.vpc}"
     dvpc_base_tags = "${data.terraform_remote_state.mel-dev.dvpc_base_tags}"
     tags = "${map("Name", "${local.vpc}-${var.application}",
                "os", "${var.os}",
                "type", "${var.type}",
                "application", "${var.application}"
  )}"
    ssh_sg = "${data.terraform_remote_state.mel-dev.ssh_sg}"
    dns_sg = "${data.terraform_remote_state.mel-dev.dns_sg}"
 }
 variable "os" {
  default = "aws_linux"
}
variable "type" {
  default = "services"
}
variable "application" {
  default = "dns"
}
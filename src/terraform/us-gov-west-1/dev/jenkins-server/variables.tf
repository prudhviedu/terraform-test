# Create tag map variables using local variables and pull in remote state values 
locals {
  region = "${data.terraform_remote_state.mel-global.region}"
  vpc = "${data.terraform_remote_state.mel-dev.vpc}"
  dvpc_base_tags = "${data.terraform_remote_state.mel-dev.dvpc_base_tags}"
  tags = "${map("Name", "${local.vpc}-${var.application}",
                "os", "${var.os}",
                "type", "${var.type}",
                "application", "${var.application}"
  )}"
  ssh_sg = "${data.terraform_remote_state.mel-dev.ssh_sg}"
  jenkins_sg = "${data.terraform_remote_state.mel-dev.jenkins_sg}"
  
  # Sets jenkins backup folder value based on environment
  jenkins_backup_folder = "${local.vpc}-jenkins-backup"
}
# TODO --update-- Availabiblty Zone Jenkins server will live in
variable "availability_zones" {
  default = "us-east-1a"
}
# TODO --update-- Subnet Jenkins server will live in
variable "subnets" {
  default = "subnet-0f47f5f39e5d3255c"
}
# TODO --update-- Private IP of the Jenkins server
variable "private_ip" {
  default = ""
}
# AWS key associated with Jenkins server
# TODO - update with correct shared key
variable "key_name" {
  default = "dev-shared-key"
}
# Instance type for Jenkins server
# TODO -- update with correct instance type
variable "instance_type" {
  default = "t2.micro"
}
variable "os" {
  default = "aws_linux"
}
variable "type" {
  default = "automation"
}
variable "application" {
  default = "jenkins"
}
# Instantiate variables passed from remote modules
variable "jenkins_backup_folder" {
  default = ""
}

variable "instance_type" {
  default = ""
}
variable "availability_zone" {
  default = ""
}
variable "vpc" {
  default = ""
}

variable "vpc_security_group_ids" {
  type = "list"
}

variable "key_name" {
  default = ""
}
variable "subnet_id" {
  default = ""
}
variable "private_ip" {
  default = ""
}

variable "tags" {
  type = "map"
}

# Instantiate variable retrieved from remote state
locals {
  jenkins-bucket = "${data.terraform_remote_state.mel-global.jenkins-bucket}"
}
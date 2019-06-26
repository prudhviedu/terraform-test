# Set provider and region
provider "aws" {
  region = "${local.region}"
}

# Create tag map variables using local variables and pull in remote state values 
locals {
  tags = "${merge(
            "${map(
                "vpc", "${var.vpc}",
                "env", "${var.env}",
                "env_host", "${var.env_host}",
                "os", "${var.os}",
                "type", "${var.type}",
                "application", "${var.application}"
            )}",
            "${data.terraform_remote_state.mel-global.base_tags}"
  )}"

  # Grab security groups from remote state
  ssh_sg = "${data.terraform_remote_state.mel-stage.ssh_sg}"

  # Grab RHEL 7 AMI_ID from the remote state
  #TODO add AMI
  rhel_ami_id = "${data.terraform_remote_state.mel-stage}"

  # TODO add subnet
  subnet_id = "${data.terraform_remote_state.mel-stage}"
  # TODO add AZ
  availability_zone = "${data.terraform_remote_state.mel-stage}"
  # TODO add Region
  region = "${data.terraform_remote_state.mel-stage}"
  
  # IAM Role assigned to the instances
  # TODO add IAM
  instance_role = "${data.terraform_remote_state.mel-stage}"
}
# Environment where deployed
variable "env" {
  default = "nonprd"
}

variable "env_host" {
  default = "nonprd"
}
# OS used by web servers
variable "os" {
  default = "RHEL7"
}

# AWS key associated with web_server server
#TODO Add key once we get an account
variable "key_name" {
  default = ""
}

# Instance type for web_server server
variable "instance_type" {
  default = "m5.large"
}

# Values for tagging web_server Server EC2 instance
variable "vpc" {
  default = "svpc"
}
# Type for instance tag
variable "type" {
  default = "web"
}
# Application name aka instance purpose
variable "application" {
  default = "MEL Apache Server"
}
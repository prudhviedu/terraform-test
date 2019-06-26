provider "aws" {
  region = "${local.region}"
}
## TODO - update region to 'us-gov-west-1' ##
terraform {
  backend "s3" {
    bucket         = "mel-terraform-remote-state-dev"
    key            = "terraform.tfstate.mel-dev-jenkins"
    dynamodb_table = "mel-terraform-lock-dev"
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
    #TODO -- append global to table name
    dynamodb_table = "mel-terraform-lock"
    region         = "us-east-1"
    encrypt        = true
  }
}
## TODO - update region to 'us-gov-west-1' ##
data terraform_remote_state "mel-dev" {
  backend = "s3" 
  config = {
    bucket         = "mel-terraform-remote-state-dev"
    key            = "terraform.tfstate.mel-dev"
    dynamodb_table = "mel-terraform-lock-dev"
    region         = "us-east-1"
    encrypt        = true
  }
}

# # Passes environemnt specific values set here to shared Jenkins Server module
module "dev-jenkins-server" {
  source = "../../../modules/jenkins-server"

  jenkins_backup_folder  = "${local.jenkins_backup_folder}"
  instance_type          = "${var.instance_type}"
  availability_zone      = "${var.availability_zones}"
  vpc_security_group_ids = ["${local.ssh_sg}", "${local.jenkins_sg}"]
  key_name               = "${var.key_name}"
  subnet_id              = "${var.subnets}"
  private_ip             = "${var.private_ip}"
  tags                   = "${merge(local.dvpc_base_tags, local.tags)}"
  vpc                    = "${local.vpc}"
}
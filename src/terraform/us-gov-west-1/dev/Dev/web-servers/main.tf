provider "aws" {
  region = "${local.region}"
}
## TODO - update region to 'us-gov-west-1' ##
terraform {
  backend "s3" {
    bucket         = "mel-terraform-remote-state-dev"
    key            = "terraform.tfstate.mel-dev-web-servers"
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
#In the dev environment, Vaausmelapp84 serves as both Apache server and weblogic server
#To keep consistency within the environments, I've added it to the web server folder
# Dev Web servers(1)
module "Vaausmelapp84_Module" {
  source = "../../../../modules/mel-server"
  env                    = "${var.env}"
  vpc                    = "${var.vpc}"
  instance_role          = "${local.instance_role}"
  ami                    = "${local.rhel_ami_id}"
  instance_type          = "${var.instance_type}"
  availability_zone      = "${local.availability_zone}"
  vpc_security_group_ids = ["${local.ssh_sg}"]
  key_name               = "${var.key_name}"
  subnet_id              = "${local.subnet_id}"
  tags                   = "${merge(
                              "${map("Name", "Vaausmelapp84"
                              )}",
                              "${local.tags}"
                          )}"
 }
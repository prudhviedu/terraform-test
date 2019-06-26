provider "aws" {
  region = "${local.region}"
}
## TODO - update region to 'us-gov-west-1' ##
terraform {
  backend "s3" {
    bucket         = "mel-terraform-remote-state-stage"
    key            = "terraform.tfstate.mel-nonprd-web-servers"
    dynamodb_table = "mel-terraform-lock-stage"
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
data terraform_remote_state "mel-stage" {
  backend = "s3" 
  config = {
    bucket         = "mel-terraform-remote-state-stage"
    key            = "terraform.tfstate.mel-stage"
    dynamodb_table = "mel-terraform-lock-stage"
    region         = "us-east-1"
    encrypt        = true
  }
}

# NonPrd Web servers(2)
module "Cemquawebmel400_Module" {
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
                              "${map("Name", "Cemquawebmel400"
                              )}",
                              "${local.tags}"
                          )}"
 }
 module "Cemquawebmel401_Module" {
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
                              "${map("Name", "Cemquawebmel401"
                              )}",
                              "${local.tags}"
                          )}"
 }
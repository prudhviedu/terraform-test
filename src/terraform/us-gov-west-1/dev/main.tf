provider "aws" {
  region = "${local.region}"
}
## TODO - update region to 'us-gov-west-1' ##
terraform {
  backend "s3" {
    bucket         = "mel-terraform-remote-state-dev"
    key            = "terraform.tfstate.mel-dev"
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
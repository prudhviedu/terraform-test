# https://www.terraform.io/docs/providers/aws/d/ami.html
# Getting latest AWS Linux 2 AMI
# TODO - Update when we decide how we will manage AMIs
data "aws_ami" "aws_linux_2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }
}

# Template file for jenkins server policy
# https://www.terraform.io/docs/providers/template/d/file.html
data "template_file" "jenkins_policy_template" {
  template = "${file("${path.module}/jenkins-server.json.template")}"

  vars {
    env = "${var.vpc}"
  }
}
## TODO -- adjust server policies and user data as needed

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
# Template file for user_data script
# https://www.terraform.io/docs/providers/template/d/file.html
data "template_file" "user_data_template" {
  template = "${file("${path.module}/user_data.sh.template")}"

  vars {
    env = "${var.vpc}"
  }
}

# Create empty S3 directory for backups
resource "aws_s3_bucket_object" "jenkins-backup-folder" {
  bucket = "${local.jenkins-bucket}"
  acl    = "private"
  key    = "${var.jenkins_backup_folder}/"
  source = "/dev/null"
}

# https://gist.github.com/clstokes/7116a368025fe6c7dfef1636df3234cf
# Create IAM Server Role and associated IAM Policy
# Uses template for server policy json object - jenkins-server.json.template
resource "aws_iam_role" "jenkins-assume-role" {
  name               = "jenkins-assume-role"
  assume_role_policy = "${file("${path.module}/jenkins-assume-role.json")}"
}

resource "aws_iam_policy" "jenkins-server-policy" {
  name        = "jenkins-server-policy"
  description = "Jenkins server policy"
  policy      = "${data.template_file.jenkins_policy_template.rendered}"
}

resource "aws_iam_policy_attachment" "jenkins-policy-attach" {
  name       = "jenkins-policy-attachment"
  roles      = ["${aws_iam_role.jenkins-assume-role.name}"]
  policy_arn = "${aws_iam_policy.jenkins-server-policy.arn}"
}

resource "aws_iam_instance_profile" "jenkins-server-profile" {
  name  = "jenkins-server-profile"
  roles = ["${aws_iam_role.jenkins-assume-role.name}"]
}

# https://www.terraform.io/docs/providers/aws/r/instance.html
# Create Jenkins Server
resource "aws_instance" "dev-jenkins-server" {
  # TODO - Update when we decide how we will manage AMIs
  ami                    = "${data.aws_ami.aws_linux_2.id}"
  instance_type          = "${var.instance_type}"
  iam_instance_profile   = "${aws_iam_instance_profile.jenkins-server-profile.name}"
  availability_zone      = "${var.availability_zone}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  key_name               = "${var.key_name}"
  subnet_id              = "${var.subnet_id}"
  associate_public_ip_address = "true"
  private_ip             = "${var.private_ip}"
  tags                   = "${var.tags}"
  user_data              = "${data.template_file.user_data_template.rendered}"
}

####################################################
#             Create EC2 Instance                  #
####################################################
resource "aws_instance" "mel-database" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  iam_instance_profile   = "${var.db_iam_instance_profile}"
  availability_zone      = "${var.availability_zone}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  key_name               = "${var.key_name}"
  subnet_id              = "${var.subnet_id}"
  tags                   = "${var.db_server_tags}"
  volume_tags            = "${var.db_server_tags}"
  user_data              = "${var.user_data}"
  private_ip             = "${var.private_ip}"
  ebs_optimized          = true
  root_block_device {
    volume_size = "${var.root_volume_size}"
    volume_type = "gp2"
    delete_on_termination = true
  }
}

########################################################################
#             Create/Attach Oracle Install EBS Mount                   #
########################################################################
# Queries AWS for the **most recent** EBS volume snapshot tagged       #
# software=oracle-install-mount and attaches it to the instance. The   #
# installer can then be mounted and run from user_data on /u01         #
########################################################################
locals{
    install_mount_name = "${var.db_server_tags["os"] == "RHEL7" ? "oracle-install-mount-rhel7" : "oracle-install-mount"}"

    iops = "${var.asm_iops == -1 ? 0 : "${var.asm_iops}"}"
}
data "aws_ebs_snapshot" "oracle_install_mount" {
    most_recent = true
    owners = ["self"]

    filter {
        name   = "tag:software"
        values = ["${local.install_mount_name}"]
    }
}

resource "aws_ebs_volume" "oracle_mount" {
  availability_zone = "${var.availability_zone}"
  size              = "${var.ebs_mount_size}"
  snapshot_id       = "${data.aws_ebs_snapshot.oracle_install_mount.id}"
  type              = "gp2"

  tags = "${merge("${var.db_ebs_tags}",
                  "${map("mount", "/u01")}"
         )}"
}

resource "aws_volume_attachment" "oracle_ebs_att" {
    device_name  = "/dev/sdo"
    volume_id    = "${aws_ebs_volume.oracle_mount.id}"
    instance_id  = "${aws_instance.mel-database.id}"
    skip_destroy = true
}
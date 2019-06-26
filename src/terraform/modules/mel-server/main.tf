# Base template file used by all MEL servers

data "template_file" "mel_server_user_data_template" {
    template = "${file("${path.module}/linux_user_data.sh.template")}"
    
}



# Module for all mel servers to use
resource "aws_instance" "mel-server" {
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  iam_instance_profile   = "${var.instance_role}"
  availability_zone      = "${var.availability_zone}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  key_name               = "${var.key_name}"
  subnet_id              = "${var.subnet_id}"
  tags                   = "${var.tags}"
  volume_tags            = "${var.tags}"
  user_data              = "${var.user_data}"
  root_block_device {
    volume_size = "${var.volume_size}"
    volume_type = "gp2"
    delete_on_termination = true
  }
  
   private_ip             = "${var.private_ip}"
}
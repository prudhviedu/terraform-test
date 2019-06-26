#Used for VAEC required tagging
output "Environment" {
  value = "${var.Environment}"
}
output "vpc" {
  value = "${var.vpc}"
}
output "vpc-id" {
  value = "${var.vpc-id}"
}
output "vpc-cidr" {
  value = "${var.vpc-cidr}"
}
# TODO -- this needs to be redone so it is using an actual variable to reference
#         use case -- need to use it in SG tags but cannot
output "dvpc_base_tags" {
  value = "${merge(
            "${map(
                "Environment", "${var.Environment}",
                "VPC", "${var.vpc}"
            )}",
            "${local.base_tags}"
  )}"
}
output "ssh_sg" {
    value   =   "${aws_security_group.ssh_sg.id}"
}
output "jenkins_sg" {
    value   =   "${aws_security_group.jenkins_sg.id}"
}
output "dns_sg" {
    value   =   "${aws_security_group.dns_sg.id}"
}
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
#         use case -- need ot uyse it in SG tags but cannot
output "stage_base_tags" {
  value = "${merge(
            "${map(
                "Environment", "${var.Environment}",
                "VPC", "${var.vpc}"
            )}",
            "${local.base_tags}"
  )}"
}

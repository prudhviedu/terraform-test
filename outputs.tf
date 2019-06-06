output "address" {
  value = "${aws_elb.web.dns_name}"
}

output "instance_id" {
  value = "${aws_instance.web.id}"
}

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "web_public_ip" {
  value = ["${aws_instance.web.public_ip}"]
}

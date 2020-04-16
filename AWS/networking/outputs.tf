#-----networking/outputs.tf----

output "public_subnets" {
  value = "${aws_subnet.tf_public_subnet.*.id}"
}

output "subnet1" {
  value = "${element(aws_subnet.tf_public_subnet.*.id, 1)}"
}

output "subnet2" {
  value = "${element(aws_subnet.tf_public_subnet.*.id, 2)}"
}

output "vpc_id" {
  value = "${aws_vpc.tf_vpc.id}"
}
output "public_sg" {
  value = "${aws_security_group.tf_public_sg.id}"
}

output "subnet_ips" {
  value = "${aws_subnet.tf_public_subnet.*.cidr_block}"
}

#-----compute/outputs.tf-----

output "server_id" {
  value = "${join(", ", aws_instance.tf_server.*.id)}"
}

output "instance1_id" {
  value = "${element(aws_instance.tf_server.*.id, 1)}"
}

output "instance2_id" {
  value = "${element(aws_instance.tf_server.*.id, 2)}"
}

output "server_ip" {
  value = "${join(", ", aws_instance.tf_server.*.public_ip)}"
}

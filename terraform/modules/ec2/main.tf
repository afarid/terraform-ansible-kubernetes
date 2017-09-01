resource "aws_instance" "ec2" {
  ami = "${var.ami_id}"
  vpc_security_group_ids = ["${split(",", var.security_group_id)}"]
  key_name = "${var.key_name}"
  instance_type = "${var.instance_type}"
  count = "${var.count}" 
  iam_instance_profile="${var.iam_instance_profile}"
  user_data = "${var.user_data}"
  subnet_id = "${element(split(",", var.subnet_id), count.index%2)}"
  tags {
    cluster_name = "${var.name}"
    role = "${var.server_role}"
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }

}
output "ec2_id" {
  value = "${join(",", aws_instance.ec2.*.id)}"
}

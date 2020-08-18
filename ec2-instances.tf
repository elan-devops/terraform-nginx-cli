
resource "aws_instance" "nginx"{
  instance_type = "m1.small"
  ami = var.AMI
  count = length(var.AVAILABILITY_ZONES)
  subnet_id = "${element(aws_subnet.default-subnets.*.id, count.index)}"
  security_groups = ["${aws_security_group.default-sg.id}"]
  user_data = "${file("nginx.sh")}"
  vpc_security_group_ids = [
    aws_security_group.default-sg.id]
  associate_public_ip_address = true
  source_dest_check = false
  key_name = "terraform-cli"
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file("/Users/elan/Desktop/terraform-cli.pem")}"
    host     = self.public_ip
    timeout = "2m"
    agent = false
  }

  provisioner "file" {
    source = "nginx.sh"
    destination = "/tmp/nginx.sh"
    }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nginx.sh",
      "sudo /tmp/nginx.sh"
    ]
  }
}
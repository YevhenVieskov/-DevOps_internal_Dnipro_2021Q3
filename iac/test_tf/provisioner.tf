resource "aws_key_pair" "my_key" {
 key_name   = "my_key"
 public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
}

resource "aws_instance" "example" {
  ami = my_ami
  instance_type = "t2.micro"
  key_name = aws_key_pair.my_key.key_name
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 50
  }
  provisioner "remote-exec" {
   inline = ["my_command"]
  }
  connection {
   host        = coalesce(self.public_ip, self.private_ip)
   agent       = true
   type        = "ssh"
   user        = "My_user_name"
   private_key = file(pathexpand("~/.ssh/id_rsa"))
  }
}
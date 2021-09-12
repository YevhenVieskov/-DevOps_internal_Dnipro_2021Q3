resource "digitalocean_droplet" "web" {
  image = "ubuntu-16-04-x64"
  name = "web-1"
  region = "sgp1"
  size = "512mb"
  ssh_keys = [12345]

  connection {
    type = "ssh"
    user = "root"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
    ]
  }
}
data "aws_ami_jenkins" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        #values = ["ebs-ssd"]
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

data "aws_ami_jenkins_slave" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        #values = ["ebs-ssd"]
         values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}


output "jenkins_image_id" {
    value = "${data.aws_ami_jenkins.ubuntu.id}"
}

output "production_image_id" {
    value = "${data.aws_ami_jenkins_slave.ubuntu.id}"
}
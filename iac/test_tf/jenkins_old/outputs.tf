output "jenkins_image_id" {
    value = "${data.aws_ami.jenkins-master-ami.id}"
}

output "jenkins_slave_image_id" {
    value = "${data.aws_ami.jenkins-slave-ami.id}"
}
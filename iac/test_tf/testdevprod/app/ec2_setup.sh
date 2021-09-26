#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2
echo 'Hello from Terraform' > /var/www/html/index.html
service httpd start

sudo apt-get install -y stress-ng

# sudo stress-ng --cpu 32 --timeout 180 --metrics-brief


                #ec2ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
                #echo "<html> <body bgcolor=0FA2B6><center><h1><p><font color=White>$ec2ip</h1><center></body></html>" > index.html
                #nohup busybox httpd -f -p 80 &

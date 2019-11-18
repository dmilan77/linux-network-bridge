# Install docker on Amazon Linux2 # node1 and node 2
systecvtl stop firewalld
systemctl status firewalls
systemctl status firewalld
yum update -y
sudo amazon-linux-extras install docker
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
docker run hello-world

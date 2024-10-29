data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical's account ID for official Ubuntu AMIs

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_ubuntu.id  # Dynamically retrieved AMI ID
  instance_type = var.instance_type
  availability_zone = var.azs
  vpc_security_group_ids = [aws_security_group.Terraform-security.id]
  subnet_id = aws_subnet.Public_terraform_subnet.id
  associate_public_ip_address = true
  # Load user data from the external file
  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "Terraform-Web-Application"
  }
  lifecycle {
    create_before_destroy = true
  }
}

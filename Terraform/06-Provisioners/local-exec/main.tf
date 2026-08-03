provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo" {

  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.micro"

  tags = {
    Name = "local-exec-demo"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > public_ip.txt"
  }

}

output "check" {
  value = "checking myself"
}

provider "aws" {
  region = "us-east-1"
}

module "ec2" {

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name = "terraform-registry-demo"

  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.micro"

  subnet_id = "subnet-0f4943239e4622530"

}

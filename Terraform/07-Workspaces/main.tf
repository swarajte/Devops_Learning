resource "aws_instance" "server" {
    ami           = "ami-0261755bbcb8c4a84"
    instance_type = "t3.micro"

    tags = {
        Name = terraform.workspace
    }
}

terraform {
  backend "s3" {
    bucket       = "terraform-workspace-bucket-swaraj"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

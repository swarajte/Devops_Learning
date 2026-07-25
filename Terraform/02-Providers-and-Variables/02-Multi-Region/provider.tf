provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

provider "aws" {
  alias  = "oregon"
  region = "us-west-2"
}

resource "aws_instance" "app1" {

  provider = aws.virginia

  ...
}

resource "aws_instance" "app1" {

  provider = aws.virginia

  ...
}



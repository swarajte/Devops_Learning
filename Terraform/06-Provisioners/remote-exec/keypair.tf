resource "aws_key_pair" "terraform_key" {

  key_name = "terraform-demo"

  public_key = file("~/.ssh/id_rsa.pub")

}

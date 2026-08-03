resource "aws_instance" "server" {

  ami           = "ami-0261755bbcb8c4a84"

  instance_type = "t3.micro"

  subnet_id = aws_subnet.public_subnet.id

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  key_name = aws_key_pair.terraform_key.key_name
  
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  }
  
  provisioner "file" {

    source = "app.py"
    destination = "/home/ubuntu/app.py"

  }
  
  provisioner "remote-exec" {

  inline = [

    "echo 'Connected to EC2 successfully!'",

    "sudo apt update -y",

    "sudo apt install -y python3-pip",

    "sudo apt install -y python3-flask",    

    "cd /home/ubuntu",

    "sudo python3 app.py &"

  ]

  }
  
  provisioner "local-exec" {
    command = "echo http://${self.public_ip}:80 > link_to_launch.txt"
  }
 
  tags = {
    Name = "terraform-remote-exec-demo"
  }

}

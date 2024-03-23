

# Creating securitygroup using Terraform
resource "aws_security_group" "TF_SG" {
  name        = "security group using Terraform"
  description = "security group using Terraform"
  vpc_id = "vpc-05272259ac938cc4c"        # Existing Default VPC in region us-east-1

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TF_SG"
  }
}

# Create keypair 

resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF_key" {
    content  = tls_private_key.rsa.private_key_pem
    filename = "tfkey"
   # file_permission = "0400"
} 


resource "aws_instance" "web_server" {
  ami           = "ami-021e5ab7e31e9ba32"       # Amazon Linux AMI - us-east-1
  instance_type = "t2.micro"
  security_groups = [aws_security_group.TF_SG.name]
  key_name = "TF_key"
  depends_on = [aws_key_pair.TF_key]

  
  tags = {
    Name = "Terraform Ec2"
  }

# terraform provisioners

 provisioner "file" {
    source      = "./test-file.txt"   # use when you want to transfer the file from local to ec2-instance
  # content     = "I want to copy this string to the destination file server.txt"   # use this when you want to create a file and add content 
    destination = "/home/ec2-user/test-file.txt"
  }
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("${var.private_key_file}")
      timeout     = "4m"
      
   }

   provisioner "local-exec" {
    command = "mkdir testdir"
    }


    #  Remote Exec provisioner

   /*  provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo helloworld remote provisioner >> hello.txt",
    ]
} */

    provisioner "remote-exec" {
       inline = [
      "sudo yum update ",   # Update the package repository
      "sudo yum install httpd -y",   # Install Apache HTTP server
      "sudo systemctl start httpd"   # Start Apache HTTP server
    ]
  }

}

# With the help of interpreter you can explicitly specify in which environment(bash, PowerShell, perl etc.) 
# you are going to execute the command.

 
/* resource "null_resource" "example1" {
  provisioner "local-exec" {
    command = "open WFH, '>hello-world.txt' and print WFH scalar localtime"
    interpreter = ["perl", "-e"]
  }
} */

/* resource "null_resource" "example2" {
  provisioner "local-exec" {
    command = "This will be written to the text file> completed.txt"
    interpreter = ["PowerShell", "-Command"]
  }
} */




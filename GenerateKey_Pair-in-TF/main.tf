provider "aws" {
   region     = "ap-south-1"
   access_key = "xxxxxxxxxxx"   # replace with your access key.
   secret_key = "xxxxxxxxx"   # replace with your secret key.
   
}



#keypair second method for Key_pair

resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF-key" {
    content  = tls_private_key.rsa.private_key_pem
    filename = "tfkey"
} 

resource "aws_instance" "example" {
  ami           = "ami-013168dc3850ef002" #Amazon Linux AMI in ap-south-1
  instance_type = "t2.micro"
  #security_groups = [aws_security_group.TF_SG.name]
  #first method
   key_name = "TF_key"
  

  tags = {
    Name = "Terraform Ec2 demo"
  }
}

resource "aws_instance" "ec2_example" {

   ami           = "ami-0e159fc62d940d348"
   instance_type =  "t2.micro"

   tags = {
           Name = "Terraform EC2"
   }
}

data "aws_instance" "myawsinstance" {
    filter {
      name = "tag:Name"
      values = ["Terraform EC2"]
    }

    depends_on = [
      aws_instance.ec2_example
    ]
}

output "fetched_info_from_aws" {
  value = data.aws_instance.myawsinstance.public_ip
}
output "tag_name" {
  value = data.aws_instance.myawsinstance.tags
}

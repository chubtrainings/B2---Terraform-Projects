
# Sample Code for Creating - Resources: Provider for AWS, AWS-EC2 Instance, AWS-VPC, AWS - Subnet.
#
# Replace Your_Access_Key - With  your Account Access Key & Your_Secret_Key: With your Your_Secret_Key

provider "aws" {
region     = "eu-central-1"
access_key = "Your_Access_Key"
secret_key = "Your_Secret_Key"
}

// 1. AWS VPC

resource "aws_vpc" "staging-vpc" {
cidr_block = "10.5.0.0/16"
tags = {
Name = "${local.staging_env}-vpc-tag"
}
}
// 2. AWS Subnet
resource "aws_subnet" "staging-subnet" {
vpc_id = aws_vpc.staging-vpc.id
cidr_block = "10.5.0.0/16"
tags = {
Name = "${local.staging_env}-subnet-tag"
}
}

// AWS Instance
resource "aws_instance" "ec2_example" {
ami           = "ami-0767046d1677be5a0"
instance_type = "t2.micro"
subnet_id = aws_subnet.staging-subnet.id
tags = {
Name = "${local.staging_env} - Terraform EC2"
}
}

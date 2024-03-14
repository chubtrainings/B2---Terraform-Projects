provider "aws" {
region     = "eu-central-1"
access_key = "AKIA6GBMGA5K5PUGWJ6L"
secret_key = "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"
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

//AWS - Users
resource "aws_iam_user" "example" {
  count = length(var.user_names)	
  name  = var.user_names[count.index]
}

#Step 1: Create a set

#Step 2: Convert set to list


#Step 3: Use count to iterate
resource "my_resource" "example" {
   count = length(local.my_list)

   name = local.my_list[count.index]

}

resource "my_resource" "example" {
   
   #Step 2: Convert list to set using toset() function 
   for_each = toset(var.my_list)

   #Step 3: Iterate over the list
   name = each.value
   # Additional resource configuration...
}




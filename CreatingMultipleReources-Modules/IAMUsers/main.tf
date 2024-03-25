#Create an IAM Policy
			resource "aws_iam_policy" "demo-s3-policy" {
			   count = "${length(var.demo-S3-Policy)}"  
			    name        = "${element(var.demo-S3-Policy,count.index )}" 
			  description = "Provides permission to access S3"

			  policy = jsonencode({
				Version = "2012-10-17"
				Statement = [
				  {
					Action = [
					  "s3:*",
					]
					Effect   = "Allow"
					Resource = [
					  "arn:aws:s3:::demo-s3-bucket",
					  "arn:aws:s3:::demo-s3-bucket/*"]
				  },
				]
			  })
			}

			#Create an IAM Role
			resource "aws_iam_role" "demo-role" {
			  name = var.demo-role

			  assume_role_policy = jsonencode({
				Version = "2012-10-17"
				Statement = [
				  {
					Action = "sts:AssumeRole"
					Effect = "Allow"
					Sid    = "RoleForEC2"
					Principal = {
					  Service = "ec2.amazonaws.com"
					}
				  },
				]
			  })
			}

			# using list of users:

            resource "aws_iam_user" "demo-user" {
             count = "${length(var.demo-user)}"
			name = "${element(var.demo-user,count.index )}"    
	
            }
		

			# using map or set
			/* resource "aws_iam_user" "example" {
  				for_each = toset(["tucker", "annie", "josh"])
  				name     = each.value
			} */

            resource "aws_iam_policy_attachment" "demo-attach" {
			  name       = var.demo-poicy-attach
			  count        = length(aws_iam_policy.demo-s3-policy)
			  roles     = [aws_iam_role.demo-role.name]
			  policy_arn  =  aws_iam_policy.demo-s3-policy[count.index].arn
			}

			

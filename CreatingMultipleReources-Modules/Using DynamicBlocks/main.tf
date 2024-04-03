


locals {
			   ingress_rules = [{
				  port        = 443
				  description = "Ingress rules for port 443"
			   },
			   {
				  port        = 80
				  description = "Ingree rules for port 80"
			   }]
			}

			resource "aws_security_group" "main" {
			   name   = "resource_with_dynamic_block"
               vpc_id = "vpc-08d04e45ff015148b"
 
			   dynamic "ingress" {
				  for_each = local.ingress_rules

				  content {
					 description = ingress.value.description
					 from_port   = ingress.value.port
					 to_port     = ingress.value.port
					 protocol    = "tcp"
					 cidr_blocks = ["0.0.0.0/0"]
				  }
			   }

			   tags = {
				  Name = "AWS security group dynamic block"
			   }
			}

            resource "aws_instance" "web_server" {
 
                ami = "ami-0e159fc62d940d348"  # Working
                instance_type = "t2.micro"
                vpc_security_group_ids = [aws_security_group.main.id]
                
                key_name = "awskey"
                               
                tags = {
                    Name = "Ec2 using dynamic-block"
                }
            }

    






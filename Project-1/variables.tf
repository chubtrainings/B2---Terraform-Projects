variable "instance_type" {
description = "Instance type t2.micro"
type        = string
default     = "t2.micro"
}
 variable "project_id" {
		   type        = string
		   description = "The Project ID"
	 }
		 
 variable "location" {
		    description = "Region for project"
		    default     = "europe-central2"
		    type        = string
	}

variable "tags" {
		   description = "Machine name"
           type = string
           default = "ec2-instance"
}




			






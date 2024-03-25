variable "demo-user" {
   type = list(string)
   default = ["prathi","akki","gayatri"]  # using list
}



variable "demo-role" {
  default = "demo-role1"
}

variable "demo-poicy-attach" {
  default = "demo-policy1"
}

variable "demo-S3-Policy" {
     type = list(string)
   default = ["policy1","policy2","policy3"]  # using list 
  
  #default = "demo-S3-Bucket-Access-Policy"
}
################ PROVIDERS ################
terraform {

  required_version = ">= 1.0.0"

  required_providers {


    tls = {
      source  = "hashicorp/tls"
      version = "4.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }

  }
}

################ VARIABLES ################

variable "username" {
  type        = string
  default     = "useradmin"
  description = "The username for which to create the password"
}


variable "path" {
  type        = string
  default     = "./keys"
  description = "The path in which to save the public and private keys"
}

variable "psw_lenght" {
  type       = number
  defautl    = 16
  descrition = "Length of the password"
}

variable "override_special" {
  type        = string
  default     = "!#%*()-_=+[]{}:?"
  description = "Specials characheter admitted for the password"
}


################ RESOURCES ################

resource "tls_private_key" "admin" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_password" "password" {
  length           = var.psw_lenght
  override_special = var.override_special
}


resource "local_file" "password" {
  content  = random_password.password.result
  filename = "${var.path}/${var.username}.txt"
}

resource "local_file" "private_openssh_key_admin" {
  content  = tls_private_key.admin.private_key_openssh
  filename = "${var.path}/${var.username}.pem"
}

resource "local_file" "public_openssh_key_admin" {
  content  = tls_private_key.admin.public_key_openssh
  filename = "${var.path}/${var.username}.pub"
}

resource "null_resource" "pem2ppk" {
  provisioner "local-exec" {
    command = var.os == "Linux" ? "puttygen ${var.path}/${var.username}.pem -o =${var.path}/${var.username}.ppk -P ${random_password.password.result}" : "winscp.com /keygen ${var.path}/${var.username}.pem /output=${var.path}/${var.username}.ppk /changepassphrase=${random_password.password.result}"
  }
  depends_on = [
    local_file.private_openssh_key_admin,
    random_password.password
  ]
}


################ OUTPUTS ################

output "password" {
  sensitive   = true
  value       = random_password.password.result
  description = "The created password"
}

output "publickey" {
  sensitive   = true
  value       = tls_private_key.admin.public_key_openssh
  description = "The puclic open SSH key"
}

locals {
staging_env = "staging"

}
locals {
   my_list = tolist(var.my_set)
}
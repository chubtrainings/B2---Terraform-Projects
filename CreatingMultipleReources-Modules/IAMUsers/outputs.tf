output "iam_user_name" {
  value = aws_iam_user.demo-user.*.name
}

output "iam_role_name" {
  value = aws_iam_role.demo-role.name
}


output "user_arn" {
  value = aws_iam_user.demo-user.*.arn  # to display all users arn in the user names list
  
}
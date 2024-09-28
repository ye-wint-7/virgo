output "account_id" {
  value = data.aws_caller_identity.whoami.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.whoami.arn
}

output "dev_vpc_arn" {
  value = aws_vpc.dev_vpc.arn
}

output "dev_public_subnet_arns" {
  value = aws_subnet.dev_public_subnet[*].arn
}

output "dev_private_subnet_arns" {
  value = aws_subnet.dev_private_subnet[*].arn
}

output "dev_db_subnet_arns" {
  value = aws_subnet.dev_db_subnet[*].arn
}
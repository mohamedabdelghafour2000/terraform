output "public_subnets_id" {
    value = aws_subnet.pub_subnets[*].id
}

output "private_subnets_id" {
    value = aws_subnet.priv_subnets[*].id
}
output "public_ec2_id" {
  value = aws_instance.pub-EC2[*].id
}

output "private_ec2_id" {
  value = aws_instance.priv-EC2[*].id
}
 
output "security_group_id" {
    value = aws_security_group.SG.id
}
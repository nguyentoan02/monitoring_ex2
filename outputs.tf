output "aws_region" {
  description = "AWS region used for deployment."
  value       = var.aws_region
}

output "vpc_id" {
  description = "ID of the custom VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "ID of the public subnet."
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "ID of the EC2 security group."
  value       = aws_security_group.ec2.id
}

output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.this.id
}

output "instance_private_ip" {
  description = "Private IP of the EC2 instance."
  value       = aws_instance.this.private_ip
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance."
  value       = aws_instance.this.public_ip
}

output "instance_iam_role_name" {
  description = "IAM role attached to the EC2 instance."
  value       = aws_iam_role.ec2.name
}

output "ssm_start_session_command" {
  description = "AWS CLI command to open an SSM shell to the instance."
  value       = "aws ssm start-session --target ${aws_instance.this.id} --region ${var.aws_region}"
}

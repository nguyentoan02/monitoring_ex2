locals {
  name_prefix = var.project_name

  common_tags = merge(
    var.tags,
    {
      Name = local.name_prefix
    }
  )
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

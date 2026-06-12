# CloudWatch Agent on EC2 with Terraform

This Terraform project creates a custom AWS network and one EC2 instance prepared for SSM access. The CloudWatch Agent installation is intentionally left for manual execution through SSM so the lab can follow the original assignment step by step.

## Resources created

- 1 custom VPC
- 1 public subnet
- 1 Internet Gateway
- 1 public route table
- 1 security group with no inbound rules
- 1 EC2 IAM role with:
  - `AmazonSSMManagedInstanceCore`
  - `CloudWatchAgentServerPolicy`
- 1 EC2 instance running Amazon Linux 2023

## Usage

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

## Connect to EC2 with SSM

After apply completes:

```powershell
aws ssm start-session --target <instance-id> --region ap-southeast-1
```

Or use the `ssm_start_session_command` Terraform output.

## CloudWatch Agent commands for the lab

Inside the SSM shell:

```bash
sudo dnf install amazon-cloudwatch-agent -y
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
sudo systemctl enable amazon-cloudwatch-agent
sudo systemctl start amazon-cloudwatch-agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
```

## Suggested screenshots

- `aws sts get-caller-identity`
- `terraform plan`
- `terraform apply`
- custom VPC
- subnet and route table
- security group
- IAM role and attached policies
- EC2 running
- Systems Manager managed node
- SSM session
- CloudWatch Agent install
- CloudWatch Agent status

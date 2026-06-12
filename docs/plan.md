# CloudWatch Agent on EC2 - Implementation Plan

## 1. Muc tieu bai lam

Tu noi dung de bai trong anh, muc tieu chinh la:

- Tao mot EC2 instance tren AWS.
- Cai dat `amazon-cloudwatch-agent` tren EC2.
- Cau hinh CloudWatch Agent bang wizard hoac file cau hinh.
- Khoi dong agent va kiem tra trang thai.
- Dam bao EC2 co IAM Role gan policy `CloudWatchAgentServerPolicy`.

Ngoai yeu cau goc trong anh, project nay se tuan theo cac rang buoc bo sung:

- Dung Terraform de tao ha tang.
- Khong dung default VPC/default subnet/default security group.
- Tao VPC, subnet, route table, security group rieng.
- EC2 duoc quan tri qua SSM Session Manager, khong dung SSH.

## 2. Cach hieu de bai

De bai khong chi yeu cau "cai mot package", ma thuc te can chung minh day du cac diem sau:

1. EC2 da duoc cap quyen IAM dung.
2. CloudWatch Agent da duoc cai dat thanh cong.
3. Agent da duoc cau hinh.
4. Agent dang chay tren may.
5. Co the kiem tra trang thai agent bang lenh.

Neu muon bai lam dep va de bao cao, nen bo sung them phan xac nhan:

- EC2 xuat hien trong Systems Manager.
- CloudWatch nhan duoc du lieu metric/log neu cau hinh gui len.

## 3. Pham vi trien khai du kien

Toi du kien lam mot project Terraform co cac thanh phan sau:

- `provider.tf`
- `variables.tf`
- `terraform.tfvars` hoac `terraform.tfvars.example`
- `main.tf` hoac tach thanh:
  - `network.tf`
  - `iam.tf`
  - `ec2.tf`
  - `outputs.tf`

Project se tao:

- 1 VPC rieng
- 1 subnet rieng
- 1 Internet Gateway
- 1 route table + route association
- 1 security group rieng
- 1 IAM role cho EC2
- 1 instance profile
- 1 EC2 Amazon Linux

## 4. Kien truc de xuat

Phuong an uu tien cho bai lab:

- 1 custom VPC
- 1 public subnet
- EC2 nam trong public subnet
- Khong mo inbound SSH
- Security group khong can inbound rule
- Outbound cho phep de cai package va giao tiep dich vu AWS
- Quan tri EC2 bang SSM Session Manager

Ly do chon phuong an nay:

- Don gian hon private subnet + NAT Gateway
- It ton chi phi hon
- Van dap ung dung yeu cau "khong dung tai nguyen mac dinh"
- De demo va chup anh

Luu y:

- EC2 dung SSM van can co cach truy cap dich vu AWS. Cach don gian nhat cho bai nay la cho instance ra internet qua public subnet.
- Neu can ban production-like hon, co the chuyen sang private subnet + VPC endpoints cho SSM/EC2Messages/SSMMessages/CloudWatch Logs.

## 5. IAM can co

IAM Role gan cho EC2 se can it nhat:

- `AmazonSSMManagedInstanceCore`
- `CloudWatchAgentServerPolicy`

Muc dich:

- `AmazonSSMManagedInstanceCore`: cho phep Session Manager quan ly va vao may.
- `CloudWatchAgentServerPolicy`: cho phep agent day metric/log len CloudWatch.

## 6. Cach thuc cai CloudWatch Agent du kien

Sau khi Terraform tao xong ha tang, quy trinh tren EC2 se la:

1. Vao EC2 bang Session Manager.
2. Cai package CloudWatch Agent.
3. Chay wizard cau hinh:
   - `/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard`
4. Enable va start service:
   - `sudo systemctl enable amazon-cloudwatch-agent`
   - `sudo systemctl start amazon-cloudwatch-agent`
5. Kiem tra:
   - `sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status`
   - Hoac `systemctl status amazon-cloudwatch-agent`

## 7. Hai huong trien khai co the chon

### Huong A - Lam sat de, thao tac tay qua SSM

Toi chi dung Terraform de dung ha tang, sau do:

- vao may bang SSM
- tu chay cac lenh cai dat
- tu chay wizard cau hinh

Uu diem:

- Sat voi de bai trong anh
- De chup anh tung buoc
- Phu hop neu giao vien muon thay ban tu thao tac

Nhuoc diem:

- It tu dong hoa hon

### Huong B - Tu dong hoa mot phan bang user data hoac SSM document

Terraform tao ha tang, roi EC2 tu cai san agent qua `user_data`.
Sau do ban chi can vao kiem tra va co the chay them lenh cau hinh.

Uu diem:

- Nhanh
- It thao tac tay

Nhuoc diem:

- Neu de bai muon the hien ro tung buoc cai dat, cach nay kem "truc quan" hon

### Lua chon de xuat

Toi de xuat **Huong A** cho project dau tien vi:

- Dung y de bai nhat
- De bao cao
- De chup anh minh chung

## 8. Cac buoc thuc hien du kien

### Phase 1 - Scaffold Terraform

- Tao cau truc thu muc Terraform
- Khai bao provider AWS va region
- Tao file variables va outputs

### Phase 2 - Tao networking rieng

- Tao VPC
- Tao subnet
- Tao Internet Gateway
- Tao route table
- Gan route table vao subnet

### Phase 3 - Tao IAM va EC2

- Tao IAM role cho EC2
- Attach `AmazonSSMManagedInstanceCore`
- Attach `CloudWatchAgentServerPolicy`
- Tao instance profile
- Tao security group rieng
- Tao EC2 Amazon Linux

### Phase 4 - Apply va xac thuc ha tang

- `terraform init`
- `terraform fmt`
- `terraform validate`
- `terraform plan`
- `terraform apply`
- Kiem tra output nhu `instance_id`, `vpc_id`

### Phase 5 - Cai CloudWatch Agent tren EC2

- Vao may qua SSM
- Cai agent
- Chay config wizard
- Start agent
- Kiem tra status

### Phase 6 - Thu thap bang chung

- Chup anh tai nguyen AWS
- Chup anh session SSM
- Chup anh terminal khi cai va kiem tra agent
- Chup anh CloudWatch neu co du lieu duoc day len

## 9. Nhung gi toi du kien se tao trong repo

Neu ban dong y cho lam project, toi du kien se tao:

- Thu muc `terraform/` hoac cac file `.tf` ngay tai root
- File README ngan huong dan chay
- Bien dau vao de doi `region`, `instance_type`, `project_name`
- Outputs de lay nhanh `instance_id`, `ssm_target`, `vpc_id`

Toi se uu tien cach to chuc de ban:

- doc de hieu
- apply de chay
- de demo

## 10. Gia dinh ky thuat hien tai

Tu thong tin ban da cung cap:

- May da cai `terraform`
- May da cai AWS CLI
- AWS CLI dang dung identity:
  - Account: `670060057454`
  - User: `monitoring`

Nhung diem can xac nhan trong qua trinh lam:

- Region se dung
- User `monitoring` co du quyen tao VPC, IAM Role, EC2, SSM, CloudWatch hay khong
- Co su dung Amazon Linux 2 hay Amazon Linux 2023

Mac dinh toi se uu tien:

- region co ban chon hoac region AWS CLI dang cau hinh
- Amazon Linux 2023 neu AMI va package ho tro on dinh

## 11. Anh can chup khi lam bai

Ban nen chup cac anh sau:

1. CLI identity
   - `aws sts get-caller-identity`

2. Terraform plan/apply thanh cong
   - man hinh terminal hien resource se tao
   - man hinh apply xong

3. VPC rieng
   - VPC dashboard hien VPC moi tao

4. Subnet va route table
   - subnet nam trong VPC moi
   - route table association

5. Security group rieng
   - khong dung default security group

6. IAM Role cua EC2
   - attach `AmazonSSMManagedInstanceCore`
   - attach `CloudWatchAgentServerPolicy`

7. EC2 running
   - instance state la `running`

8. Systems Manager
   - Managed node/instance hien online

9. Session Manager
   - man hinh vao duoc shell cua EC2

10. Cai CloudWatch Agent
   - lenh cai package thanh cong

11. Cau hinh va start agent
   - wizard hoac lenh start

12. Kiem tra trang thai
   - `amazon-cloudwatch-agent-ctl -m ec2 -a status`
   - hoac `systemctl status amazon-cloudwatch-agent`

13. CloudWatch
   - neu co metric/log thi chup man hinh xac nhan da gui len

## 12. Cach chup anh tren Windows

Co the dung:

- `Win + Shift + S` de chup nhanh theo vung
- `Snipping Tool` de chup va luu file

Dat ten file nen ro rang theo thu tu:

- `01-identity.png`
- `02-terraform-plan.png`
- `03-terraform-apply.png`
- `04-vpc.png`
- `05-subnet-route-table.png`
- `06-security-group.png`
- `07-iam-role.png`
- `08-ec2-running.png`
- `09-ssm-managed-node.png`
- `10-ssm-session.png`
- `11-install-agent.png`
- `12-agent-status.png`
- `13-cloudwatch.png`

## 13. Tieu chi hoan thanh

Toi xem project dat muc tieu khi:

- Terraform tao duoc ha tang rieng, khong dung default VPC
- EC2 co the vao bang SSM
- CloudWatch Agent duoc cai va chay thanh cong
- EC2 IAM Role co `CloudWatchAgentServerPolicy`
- Co bang chung terminal/AWS Console cho tung buoc quan trong

## 14. Ke hoach thuc thi sau khi ban dong y

Neu ban cho phep toi lam project, toi se thuc hien theo thu tu:

1. Tao scaffold Terraform.
2. Tao network rieng.
3. Tao IAM role + instance profile.
4. Tao EC2 + SSM-ready configuration.
5. Chay validate/plan.
6. Huong dan ban apply hoac toi apply neu duoc phep.
7. Huong dan vao SSM va cai CloudWatch Agent.
8. Huong dan chup anh dung thoi diem.

## 15. De xuat nho truoc khi bat dau

Toi de xuat ban duyet 3 diem nay truoc:

- Dung **Huong A**: dung ha tang bang Terraform, cai agent thu cong qua SSM.
- Dung **custom VPC + public subnet**, khong mo SSH.
- Dung **AmazonSSMManagedInstanceCore** + **CloudWatchAgentServerPolicy** cho EC2 Role.

## FOR Info purpose only. Please see the README in root of the project.

# resource "aws_msk_serverless_cluster" "enterprise_msk_cluster" {
#     cluster_name = "enterprise-msk-serverless-cluster"

#     vpc_config {
#         subnet_ids         = [for s in aws_subnet.enterprise_subnet : s.id]
#         security_group_ids = [aws_security_group.enterprise_sg.id]
#     }

#     client_authentication {
#         sasl {
#             iam {
#                 enabled = true
#             }
#         }
#     }
# }

# resource "aws_iam_policy" "enterprise_msk_api_policy" {
#     name        = "enterprise_msk_api_policy"
#     path        = "/"
#     description = "Enterprise MSK Service API Policy"

#     policy = jsonencode({
#         Version = "2012-10-17",
#         Statement = [
#             {
#                 Sid = "VisualEditor0",
#                 Effect = "Allow",
#                 Action = "kafka-cluster:*",
#                 Resource = "*"
#             }
#         ]
#     })
# }



# resource "aws_iam_role" "enterprise_msk_role" {
#     name = "enterprise_msk_role"

#     assume_role_policy = jsonencode({
#         Version = "2012-10-17",
#         Statement = [
#             {
#                 Effect = "Allow",
#                 Action = "sts:AssumeRole",
#                 Principal = {
#                     Service = "kafka.amazonaws.com"
#                 }
#             },
#             {
#                 Effect = "Allow",
#                 Action = "sts:AssumeRole",
#                 Principal = {
#                     Service = "ec2.amazonaws.com"
#                 }
#             }
#         ]
#     })

#     managed_policy_arns = [
#         "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
#         "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
#     ]

#     tags = {
#         Purpose = "Combined Role for MSK Serverless and SSM"
#     }
# }

# resource "aws_iam_role_policy_attachment" "enterprise_attach_msk_api_policy" {
#     role       = aws_iam_role.enterprise_msk_role.name
#     policy_arn = aws_iam_policy.enterprise_msk_api_policy.arn
# }

# resource "aws_iam_instance_profile" "enterprise_instance_profile" {
#     name = "enterprise_instance_profile"
#     role = aws_iam_role.enterprise_msk_role.name
# }

# resource "aws_iam_policy" "ec2_instance_connect_policy" {
#     name        = "EC2InstanceConnectPolicy"
#     description = "Policy to allow EC2 Instance Connect"
#     policy      = jsonencode({
#         Version = "2012-10-17",
#         Statement = [
#             {
#                 Effect = "Allow",
#                 Action = [
#                     "ec2-instance-connect:SendSSHPublicKey"
#                 ],
#                 Resource = [
#                     "arn:aws:ec2:*:*:instance/*"
#                 ]
#             }
#         ]
#     })
# }

# resource "aws_iam_user" "bhaumik_patel" {
#     name = "bhaumik.patel"
# }

# resource "aws_iam_user_policy_attachment" "attach_user" {
#     user       = aws_iam_user.bhaumik_patel.name
#     policy_arn = aws_iam_policy.ec2_instance_connect_policy.arn
# }

# resource "aws_instance" "enterprise_msk_ui_instance" {
#     ami           = "ami-0c55b159cbfafe1f0"
#     instance_type = "t3.medium"
#     iam_instance_profile = aws_iam_instance_profile.enterprise_instance_profile.name
#     key_name = "bhaumik.patel"

#     vpc_security_group_ids = [aws_security_group.enterprise_sg.id]
#     subnet_id              = aws_subnet.enterprise_subnet[0].id

#     associate_public_ip_address = true

#     user_data = <<-EOF
#                     #!/bin/bash
#                     exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

#                     echo "Updating packages"
#                     sudo apt-get update

#                     echo "Installing Java JDK"
#                     sudo apt-get install -y default-jdk

#                     echo "Installing Docker"
#                     sudo apt-get install -y docker.io
#                     sudo systemctl start docker
#                     sudo systemctl enable docker
#                     sudo apt-get install -y docker-compose

#                     echo "Downloading and installing Kafka"
#                     wget https://archive.apache.org/dist/kafka/2.5.0/kafka_2.12-2.5.0.tgz
#                     tar -xzf kafka_2.12-2.5.0.tgz
#                     sudo mv kafka_2.12-2.5.0 /opt/kafka

#                     echo "Downloading AWS MSK IAM Auth"
#                     curl -L -o aws-msk-iam-auth-1.1.1-all.jar \
#                     https://github.com/aws/aws-msk-iam-auth/releases/download/v1.1.1/aws-msk-iam-auth-1.1.1-all.jar
#                     sudo mv aws-msk-iam-auth-1.1.1-all.jar /opt/kafka/libs/

#                     echo "Running Kafka UI Docker container"
#                     sudo docker run -d -p 8080:8080 \
#                     -e DYNAMIC_CONFIG_ENABLED=true \
#                     provectuslabs/kafka-ui

#                 EOF

#     tags = {
#         Name = "Enterprise-MSK-UI-Service"
#     }
# }

data "aws_ip_ranges" "cloudfront" {
    services = ["CLOUDFRONT"]
}

data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_vpc" "enterprise_vpc" {
    # Using CIDR 10.100.0.0/22 to allow upto 1024 ip address for the subnet to have upto 256 ip avail.
    cidr_block = "10.100.0.0/22"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "enterprise-vpc"
    }
}

resource "aws_subnet" "enterprise_public_subnet" {
    count             = min(2, length(data.aws_availability_zones.available.names))
    vpc_id            = aws_vpc.enterprise_vpc.id
    cidr_block        = cidrsubnet(aws_vpc.enterprise_vpc.cidr_block, 4, count.index)
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    map_public_ip_on_launch = true
    tags = {
        Name = "enterprise-public-subnet-${count.index}"
    }
}

resource "aws_subnet" "enterprise_private_subnet" {
    count             = min(2, length(data.aws_availability_zones.available.names))
    vpc_id            = aws_vpc.enterprise_vpc.id
    cidr_block        = cidrsubnet(aws_vpc.enterprise_vpc.cidr_block, 4, count.index + 2)
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    map_public_ip_on_launch = false
    tags = {
        Name = "enterprise-private-subnet-${count.index}"
    }
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.enterprise_vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.enterprise_public_subnet[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.enterprise_private_subnet[*].id
}


data "aws_ip_ranges" "ec2_instance_connect" {
    services = ["EC2_INSTANCE_CONNECT"]
}

# ALB security group for public subnet only for micro service
resource "aws_security_group" "enterprise_sg_alb" {
    name   = "enterprise-security-group-alb"
    vpc_id = aws_vpc.enterprise_vpc.id

    # Allow outgoing traffic to AWS services, 
    egress {
        from_port   = 443
        to_port     = 443
        protocol    = "HTTPS"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow ingress traffic on HTTP (port 80) from CloudFront IP ranges
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = data.aws_ip_ranges.cloudfront.cidr_blocks
    }

}

# Microservice ECS security group
resource "aws_security_group" "enterprise_sg_ms" {
    name   = "enterprise-security-group-ms"
    vpc_id = aws_vpc.enterprise_vpc.id

    # Ingress rule to allow traffic from ALB on port 80
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = [aws_security_group.enterprise_sg_alb.id]
    }

    # Allow outgoing traffic to AWS services, 
    egress {
        from_port   = 443
        to_port     = 443
        protocol    = "HTTPS"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# MSK SG group for info purpose only
# resource "aws_security_group" "enterprise_sg_msk" {
#     name   = "enterprise-security-group-msk"
#     vpc_id = aws_vpc.enterprise_vpc.id

#     # Allow outgoing traffic to AWS services, 
#     egress {
#         from_port   = 443
#         to_port     = 443
#         protocol    = "HTTPS"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     # MSK default ports for client communication on EC2 for demonstration purpose
#     ingress {
#         from_port   = 9092
#         to_port     = 9092
#         protocol    = "tcp"
#         cidr_blocks = [aws_security_group.enterprise_sg_ms.id]
#     }
#     ingress {
#         from_port   = 9098
#         to_port     = 9098
#         protocol    = "tcp"
#         cidr_blocks = [aws_security_group.enterprise_sg_ms.id]
#     }
#     # Kafka UI access for my ip
#     ingress {
#         from_port   = 8080
#         to_port     = 8080
#         protocol    = "tcp"
#         cidr_blocks = ["my_ip"]
#     }
# }
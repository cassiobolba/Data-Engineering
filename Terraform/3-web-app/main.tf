terraform {
  # Assumes s3 bucket and dynamo DB table already set up
  # See /code/03-basics/aws-backend
  backend "s3" {
    bucket         = "cabolba88-tf-state-dev" # REPLACE WITH YOUR BUCKET NAME
    key            = "03-basics/import-bootstrap/terraform.tfstate" # WHERE IN THE BUCKET THE STATE FILE WILL BE
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking" # TABLE NAME
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "instance_1" {
  ami             = "ami-011899242bb902164" # Ubuntu 20.04 LTS // us-east-1
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instances.name] # Define security groups to allow inbound traffic
  # simple commandos to put a hello workd on a html index and initiate a python http.server on port 8080
  user_data       = <<-EOF
              #!/bin/bash
              echo "Hello, World 1" > index.html
              python3 -m http.server 8080 &
              EOF
}

resource "aws_instance" "instance_2" {
  ami             = "ami-011899242bb902164" # Ubuntu 20.04 LTS // us-east-1
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instances.name]
  user_data       = <<-EOF
              #!/bin/bash
              echo "Hello, World 2" > index.html
              python3 -m http.server 8080 &
              EOF
}

# this bucket is actually not used but is just to demonstrate in case you need, it is possible to do
resource "aws_s3_bucket" "bucket" {
  bucket        = "devops-directive-web-app-data"
  force_destroy = true
  versioning {
    enabled = true
  }
    # encryption example to demontrate how to secure the bucket
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# data blocks are used to reference existing infrastructre already deployed in the cloud
# here is using as vpc the default one that is already deployed
data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "default_subnet" {
  vpc_id = data.aws_vpc.default_vpc.id
}

# creating security group 
resource "aws_security_group" "instances" {
  name = "instance-security-group"
}

# attaching policies to a security group, allowing http inbound rule
resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress" # type of traffic
  security_group_id = aws_security_group.instances.id # the security group to implement

  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # allowing all ip adresses
}

# set up an http load balancer
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn

  port = 80

  protocol = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"
    # custom 404 message
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

# define a target group to cdefine where the traffic goes 
# it will ontain our EC2 instances and then we  monitor the group with some health checks
resource "aws_lb_target_group" "instances" {
  name     = "example-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# attach the EC2 instances to the target group, then load balancer knows where to route the traffic
resource "aws_lb_target_group_attachment" "instance_1" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id        = aws_instance.instance_1.id
  port             = 8080
}

# attach the EC2 instances to the target group, then load balancer knows where to send the traffic
resource "aws_lb_target_group_attachment" "instance_2" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id        = aws_instance.instance_2.id
  port             = 8080
}

# 
resource "aws_lb_listener_rule" "instances" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instances.arn
  }
}


resource "aws_security_group" "alb" {
  name = "alb-security-group"
}

resource "aws_security_group_rule" "allow_alb_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "allow_alb_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

}

# the load balancer itself
resource "aws_lb" "load_balancer" {
  name               = "web-app-lb"
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default_subnet.ids
  security_groups    = [aws_security_group.alb.id]

}

resource "aws_route53_zone" "primary" {
  name = "devopsdeployed.com"
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "devopsdeployed.com"
  type    = "A"

  alias {
    name                   = aws_lb.load_balancer.dns_name
    zone_id                = aws_lb.load_balancer.zone_id
    evaluate_target_health = true
  }
}

# database just to be a sample
# resource "aws_db_instance" "db_instance" {
#   allocated_storage   = 20
#   storage_type        = "standard"
#   engine              = "postgres"
#   engine_version      = "12.5"
#   instance_class      = "db.t2.micro"
#   name                = "mydb"
#   username            = "foo"
#   password            = "foobarbaz"
#   skip_final_snapshot = true
# }
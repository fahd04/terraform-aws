data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "this" {
  name_prefix = "${var.name}-"
  description = "Security group for ${var.name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = length(var.allowed_cidr_blocks) > 0 ? [1] : []
    content {
      description = "App traffic from allowed CIDRs"
      from_port   = var.app_port
      to_port     = var.app_port
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidr_blocks
    }
  }

  dynamic "ingress" {
    for_each = length(var.allowed_security_group_ids) > 0 ? [1] : []
    content {
      description     = "App traffic from allowed security groups"
      from_port       = var.app_port
      to_port         = var.app_port
      protocol        = "tcp"
      security_groups = var.allowed_security_group_ids
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name}-sg" }

  lifecycle {
    create_before_destroy = true
  }
}

# Shell access goes through SSM Session Manager instead of SSH,
# so no key pair is managed and port 22 stays closed.
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name_prefix        = "${var.name}-"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "read_secrets" {
  count = length(var.readable_secret_arns) > 0 ? 1 : 0

  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = var.readable_secret_arns
  }
}

resource "aws_iam_role_policy" "read_secrets" {
  count = length(var.readable_secret_arns) > 0 ? 1 : 0

  name   = "read-secrets"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.read_secrets[0].json
}

resource "aws_iam_instance_profile" "this" {
  name_prefix = "${var.name}-"
  role        = aws_iam_role.this.name
}

resource "aws_instance" "this" {
  count = var.instance_count

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile   = aws_iam_instance_profile.this.name

  metadata_options {
    http_tokens = "required" # IMDSv2 only
  }

  root_block_device {
    volume_type = "gp3"
    encrypted   = true
  }

  tags = { Name = "${var.name}-${count.index}" }

  lifecycle {
    ignore_changes = [ami] # new AMI releases should not force replacement
  }
}

resource "aws_eip" "this" {
  count = var.assign_eip ? var.instance_count : 0

  domain   = "vpc"
  instance = aws_instance.this[count.index].id

  tags = { Name = "${var.name}-eip-${count.index}" }
}

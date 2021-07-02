locals {
  name        = var.namespace == "" ? lower(var.name) : "${lower(var.namespace)}-${lower(var.name)}"
  common_tags = {
    Name = local.name
  }
}


resource "aws_security_group" "bastion_host_security_group" {
  description = "Enable SSH access to the bastion host from external via SSH port"
  name        = "${local.name_prefix}-host"
  vpc_id      = var.vpc_id
  tags = merge(var.tags)
}

resource "aws_security_group_rule" "ingress_bastion" {
  description = "Incoming traffic to bastion"
  type        = "ingress"
  from_port   = var.public_ssh_port
  to_port     = var.public_ssh_port
  protocol    = "TCP"
  cidr_blocks = var.ingress_cidrs

  security_group_id = aws_security_group.bastion_host_security_group.id
}

resource "aws_security_group_rule" "egress_bastion" {
  description = "Outgoing traffic from bastion to instances"
  type        = "egress"
  from_port   = "0"
  to_port     = "65535"
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.bastion_host_security_group.id
}


resource "aws_instance" "this" {
  instance_type = var.instance_type
  ami           = data.aws_ami.ubuntu.image_id


  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
    }
  }

  vpc_security_group_ids      = [aws_security_group.bastion_host_security_group.id]
  credit_specification {
    cpu_credits = var.cpu_credits
  }
  key_name = var.key_name
  tags = merge(var.tags,local.common_tags)

  lifecycle {
    ignore_changes = [user_data, associate_public_ip_address]
  }

}

//////////////////////////////////////////////
////// EIP:
//////////////////////////////////////////////
resource "aws_eip" "this" {
  count    = var.associate_public_ip_address ? 0 : 1
  vpc      = true
  instance = aws_instance.this.id
  tags     = merge(var.tags,local.common_tags)
}


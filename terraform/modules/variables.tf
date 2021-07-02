variable "name" {
  description = "The name of the instance"
  type        = string
  default = "bastion-ec2"
}
variable "namespace" {
  description = "The namespace of the instance"
  type        = string
  default     = ""
}
variable "instance_type" {
  description = "The instance type of the instance like (t2.micro)"
  type        = string
// default = "t2.micro" 
}
variable "ami" {
  description = "The AMI of the instance"
  type        = string
  default = "ami-08962a4068733a2b6"
}
//variable "iam_instance_profile" {
//  description = "The instance_profile to use"
//  type        = string
//}
variable "protect_termination" {
  description = "Whether or not the instance will be protected from termination"
  type        = bool
  default     = true
}
variable "cpu_credits" {
  description = "The CPU credits to use"
  type        = string
  default     = "unlimited"
}
variable "key_name" {
  description = "The name of SSH Key Pair"
  type        = string
}

variable "ebs_optimized" {
  description = "Whether or not the ebs is optimized"
  type        = bool
  default     = true
}
variable "associate_public_ip_address" {
  description = "Whether or not assign public ip for the instance"
  type        = bool
  default     = false
}
variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(map(string))
  default     = []
}
variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = " "
}

variable "tags" {
  description = "Tags of the instance"
  type        = map
  default = {
    Terraform   = "true"
    Environment = "Bastion"
  }
}

variable "vpc_id" {
  description = "VPC id were we'll deploy the bastion"
//  default = "vpc-b5b640c8" 
}

variable "public_ssh_port" {
  description = "Set the SSH port to use from desktop to the bastion"
  default     = 22
}

variable "private_ssh_port" {
  description = "Set the SSH port to use between the bastion and private instance"
  default     = 22
}

variable "ingress_cidrs" {
  description = "List of CIDRs than can access to the bastion. Default : 0.0.0.0/0"
  type        = list(string)

  default = [
    "0.0.0.0/0",
  ]
}

variable "bastion_launch_template_name" {
  description = "Bastion Launch template Name, will also be used for the ASG"
  default     = "bastion-lt"
}

variable "ebs_volume_size" {
  description = "EBS volume size"
  type = string
  default = 8
}

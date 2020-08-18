variable "AWS_REGION"{
  default = "us-east-1"
}

variable "AVAILABILITY_ZONES" {
  type = list
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "SUBNETS_CIDR" {
  type = list
  default = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
}

variable "AMI" {
  default = "ami-04169656fea786776"
}

variable "NO_OF_INSTANCES" {
  default = 3
}
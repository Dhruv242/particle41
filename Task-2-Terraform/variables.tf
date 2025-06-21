variable "cluster-name" {
  type    = string
  default = "particle-dk-eks"
}

variable "scaling" {
  description = "The scaling capacity of the cluster."
  type        = map(any)
  default = {
    desired = 4
    max     = 4
    min     = 4
  }
}

variable "sg_name" {
  description = "Default security group for the cluster."
  type        = string
  default     = "kube_sg"
}

variable "subnets" {
  description = "Subnets for public and private."
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    env      = "Training templates"
  }
}

variable "vpc_cidr" {
  description = "CIDR block used by the main VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "workstation-external-cidr" {
  type    = string
  default = "0.0.0.0/0"
}


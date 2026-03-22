#Variables
variable "region" {
  description = "Region where you want to create instances"
  type        = string
  default     = "us-east-2"

}

variable "instance_type_list" {
  description = "Instance type"
  type        = list(string)
  default     = ["t3.micro", "t2.micro"]
  sensitive   = false
}

variable "instance_type_map" {
  description = "Instance type"
  type        = map(string)
  default = {
    "dev"  = "t3.micro"
    "UAT"  = "t3.medium"
    "Prod" = "t3.large"
  }
  sensitive = false
}


variable "ami" {
  description = "Ami id which we are going to use"
  type        = string
  default     = "ami-0b0b78dcacbab728f"
}

variable "instance_keypair" {
  description = "AWS EC2 Key pair that need to be associated with the EC2 instance"
  type        = string
  default     = "terraform-key"

}

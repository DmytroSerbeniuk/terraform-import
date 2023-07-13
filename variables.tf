variable "region" {
  type        = string
  description = "AWS region for deploy"
  default     = "eu-central-1"
}

variable "tags" {
  description = "Tags for resource"
  type        = map(string)
  default     = { Project = "new", Terraform = "true" }
}


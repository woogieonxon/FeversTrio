
variable "repository_name" {
  type        = string
  description = "Name of the ECR repository to create."
}

variable "image_tag_mutability" {
  type        = string
  description = "The tag mutability settings for the repository."
  default     = "MUTABLE"
}

variable "scan_on_push" {
  type        = bool
  description = "Indicates whether images are scanned after being pushed to the repository."
  default     = false
}

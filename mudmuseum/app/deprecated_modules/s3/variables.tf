variable "bucket" {
  description = "The name of the bucket."
  type        = string
  default     = null
}

variable "logging_target_bucket" {
  description = "Bucket to send standard logs to."
  type        = string
}

variable "logging_target_prefix" {
  description = "Prefix for standard logs sent to the logging_target_bucket."
  type        = string
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  default     = false
}

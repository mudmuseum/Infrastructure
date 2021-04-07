variable "name" {

  description = "Name for the IAM Policy."
}

variable "description" {

  description = "Description for the IAM Policy."
  default     = ""
}

variable "policy" {

  description = "A JSON Policy to apply within the IAM Policy resource."
}

# variable "actions" {

#   description = "A list of actions for the IAM Policy." 
#   type        = "list"
# }

# variable "resources" {

#   description = "A list of resources the IAM Policy applies to."
#   type        = "list"
# }

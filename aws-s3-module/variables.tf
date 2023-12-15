variable "bucket" {
    type = string
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "lifecycle_id" {
  type = string
}

variable "lifecycle_days" {
  type = number
}

variable "lifecycle_prefix" {
  type = string
}

variable "lifecycle_status"{
  type = string
}

variable "replication_id" {
  type = string
}

variable "replication_prefix" {
  type = string
}

variable "replication_status" {
  type = string
}

variable "replication_destination" {
  type = string
}

variable "role" {
  type = string
}
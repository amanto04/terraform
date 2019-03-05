variable "ssh_key_public" {
  default     = "~/.ssh/personal/webserver.pub"
  description = "ssh public key for the aws instance"
}

variable "ssh_key_private" {
  default     = "~/.ssh/personal/webserver"
  description = "ssh private key for the aws instance"
}

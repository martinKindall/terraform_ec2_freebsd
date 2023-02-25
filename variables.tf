variable "ami" {
    type = string
    default = "ami-060fa82bd8f35157d" # freeBSD 12.4
}

variable "instance_type" {
    type = string
    default = "t3.small"
}
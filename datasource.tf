/*
Data sources in Terraform are used to retrieve information about existing 
resources that are not managed by Terraform. They allow you to use this 
information in your configurations, enabling you to reference and utilize 
existing infrastructure dynamically.
*/
# data "aws_vpc" "testing" {
#   id = "vpc-080a45eecf6979ae7"
# }

# resource "aws_internet_gateway" "IGW" {
#   vpc_id = data.aws_vpc.testing.id

#   tags = {
#     Name = "Testing-IGW"
#   }
# }
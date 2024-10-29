# Output the public IP of the instance
output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "Public IP of the web server instance"
}
output "instance_public_ip" {
    description = "The Public Ip is:"
    value = aws_instance.test_server.public_ip
  
}
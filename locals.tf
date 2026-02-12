locals {
  ingress_rule = [{
    port        = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    description = "allow http traffic"
    },
    {
      port        = 22
      cidr_blocks = ["102.219.210.250/32"]
      protocol    = "tcp"
      description = "allow ssh traffic"
    }
  ]
}

resource "aws_instance" "k3s" {
  ami           = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type = var.ec2_instance_type

  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.ec2.id]

  iam_instance_profile = aws_iam_instance_profile.ec2.name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  root_block_device {
    volume_size = var.ec2_root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name    = "${var.project_name}-k3s"
    Project = var.project_name
  }
  user_data = <<-EOF
  #!/bin/bash

  snap install amazon-ssm-agent --classic
  systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
  systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service
EOF




}
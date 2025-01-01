# Add the local provider to your configuratterraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Use the local_file resource to save output to a file
resource "local_file" "output_file" {
  content  = <<EOT
Instance Public IP: ${aws_instance.example.public_ip}
VPC ID: ${aws_vpc.main.id}
EOT
  filename = "${path.module}/outputs.txt"
}

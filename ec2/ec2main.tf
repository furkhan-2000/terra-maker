data "aws_ami" "sast" {
  most_recent = true
  owners      = var.aws_ami_owner

  filter {
    name   = "name"
    values = [var.aws_ami_value]
  }
}

/*resource "aws_key_pair" "samsung" {
  key_name   = var.aws_key_name                     #   bcz we have key 
  public_key = file("apple.pub")
} */

resource "aws_default_vpc" "hyd-vpc" {
}

resource "aws_security_group" "hyd-aws_subnet" {
  name   = var.aws_security_group_name
  vpc_id = aws_default_vpc.hyd-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "hyd-machine" {
  for_each      = toset(var.instance_type_workspace[terraform.workspace]) # only env specific will pick 
  ami           = data.aws_ami.sast.id
  instance_type = each.value #var.env == "dev" ? "t2.micro" : "t2.medium"
  #count                  = var.instance_count # for creating multiple instance without diff name
  key_name               = var.aws_key_name
  user_data              = file("userdata.sh")
  vpc_security_group_ids = [aws_security_group.hyd-aws_subnet.id]

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price                      = var.spot_price[terraform.workspace]
      spot_instance_type             = var.spot_instance_type
      instance_interruption_behavior = var.interruption_behavior
    }
  }

  root_block_device {
    volume_size = var.volume_size[terraform.workspace] # used when multiple env in same file: var.env == "dev" ? 9 : var.env == "prd" ? 11 : 8
    volume_type = var.volume_type[terraform.workspace] #var.env == "prd" ? "gp3" : "gp2"
  }

  tags = {
    Name = "ryl-${terraform.workspace}-${each.key}" # Dynamically names each instance as hyd-gun-1, hyd-gun-2, etc. 
    Env  = terraform.workspace
  }
}


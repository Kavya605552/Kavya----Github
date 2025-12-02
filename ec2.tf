resource "aws_key_pair" "mykey"{
    key_name   = "ec2-key"
    public_key = file("ec2-key.pub")
}
resource "aws_default_vpc" "default"{
    
}
resource aws_security_group my_security_group{
    name        = "my_security_group"
    description = "Security group for my EC2 instance"
    vpc_id      = aws_default_vpc.default.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress{
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
     }
}
resource "aws_instance" "my_ec2_instance" {
    count=2
    ami           = "ami-00f46ccd1cbfb363e"  # Amazon Linux 2 AMI (us-west-2)
    instance_type = "t3.micro"
    key_name      = aws_key_pair.mykey.key_name
    security_groups = [aws_security_group.my_security_group.name]
    user_data = file("install_nginx.sh")
    root_block_device {
      volume_size = var.aws_root_storage_size
      volume_type = "gp3"
    }
    tags = {
        Name = "MyEC2Instance"
    }
}
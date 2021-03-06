data "aws_ami" "amazon_linux_ecs" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2*"]
  }
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

/*
resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = file("~/.ssh/id_rsa.pub")
}
*/

resource "aws_launch_configuration" "ecs_launch_config" {
    image_id             = data.aws_ami.amazon_linux_ecs.id
    iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
    security_groups      = [aws_security_group.ecs_sg.id]
    //associate_public_ip_address = true
    //key_name             = aws_key_pair.mykeypair.key_name
    instance_type        = "t3.medium"
    spot_price           = "0.017" //https://aws.amazon.com/ec2/spot/pricing/
    user_data            = file("scripts/init.sh")
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
    name                      = "asg"
    vpc_zone_identifier       = [aws_subnet.priv_subnet.id]
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name

    desired_capacity          = 1
    min_size                  = 1
    max_size                  = 2
    health_check_grace_period = 300
    health_check_type         = "EC2"

    depends_on = [
      aws_route_table_association.priv_route,
      aws_route_table_association.pub_route
    ]
}
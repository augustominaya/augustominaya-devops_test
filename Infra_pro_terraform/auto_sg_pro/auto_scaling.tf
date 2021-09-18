variable "web_server_config" {
}
variable "load_balance_conf" {
}
variable "cluster_name" {
}

variable "subnetlist" {

}

# autoscaling_group configuration

resource "aws_autoscaling_group" "web-auto-scaling" {
  launch_configuration    = var.web_server_config.name
  min_size                = "2"
  max_size                = "4"
  load_balancers          = [var.load_balance_conf.id]
  health_check_type       = "ELB"
  #vpc_zone_identifier     = ["subnet-2eeae963"]
  vpc_zone_identifier     = "${var.subnetlist}"

  tags = concat([
{
"key" = "Name"
"value" = "${var.cluster_name}-ASG"
"propagate_at_launch" = true
}]
)
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "cpu-usage" {
  name                    = "${var.cluster_name}-asg-cpu-policy"
  autoscaling_group_name  = "${aws_autoscaling_group.web-auto-scaling.name}"
  policy_type             = "TargetTrackingScaling"
  target_tracking_configuration {
  predefined_metric_specification {
  predefined_metric_type  = "ASGAverageCPUUtilization"
    }
    target_value          = 40.0
  }
}
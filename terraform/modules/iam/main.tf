#Create new IAM role for cloudwatch access
resource "aws_iam_role" "ec2_role_to_full_access_cloudwatch" {
  name               = "${var.name}-ec2_role_to_full_access_cloudwatch"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

#Create the required policy to addign it to IAM role
resource "aws_iam_policy" "cloudwatch_full_access" {
  name        = "${var.name}-cloudwatch_full_access"
  description = "Grant ec2 full access to cloudwatch"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

#Attach policy to IAM role
resource "aws_iam_role_policy_attachment" "cloudwatch_attach" {
  role       = "${aws_iam_role.ec2_role_to_full_access_cloudwatch.name}"
  policy_arn = "${aws_iam_policy.cloudwatch_full_access.arn}"
}

#Attach IAM role to instance profile
resource "aws_iam_instance_profile" "cloudwatch_access_profile" {
  name  = "${var.name}-cloudwatch_access_profile"
  role = "${aws_iam_role.ec2_role_to_full_access_cloudwatch.name}"
}

#Generate the output variables
output "cloudwatch_access_profile" {
  value = "${aws_iam_instance_profile.cloudwatch_access_profile.name}"
}

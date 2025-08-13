resource "aws_iam_group" "test-group-uday" {
  name = "test-group-uday"
}

resource "aws_iam_user" "iam-user" {
  name = var.iam_user_name
}

resource "aws_iam_user_group_membership" "user_group_attachement" {
  user   = aws_iam_user.iam-user.id
  groups = [aws_iam_group.test-group-uday.id]
}

resource "aws_iam_group_policy" "group_policy" {
  name  = "test-group-uday-policy"
  group = aws_iam_group.test-group-uday.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowEc2andAllowVpcFullAccess",
        "Effect" : "Allow",
        "Action" : ["ec2:*"],
        "Resource" : "*"
      }
    ]
  })
}

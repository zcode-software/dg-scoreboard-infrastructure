resource "aws_iam_openid_connect_provider" "github_cicd_idp" {
  url = var.github_cicd_issuer_url

  client_id_list = [
    var.github_cicd_client_id,
  ]
}

resource "aws_iam_role" "github_cicd_role" {
  name = "github-actions-deployment-role"
  assume_role_policy = data.aws_iam_policy_document.github_cicd_assume_role_policy.json
}

resource "aws_iam_role_policy" "github_cicd_role_s3_access_policy" {
  name = "github-actions-deployment-s3-policy"
  role = aws_iam_role.github_cicd_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action: [
          "cloudfront:CreateInvalidation"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "github_cicd_role_cf_access_policy" {
  name = "github-actions-deployment-cf-policy"
  role = aws_iam_role.github_cicd_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action: [
          "s3:DeleteObject",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:ListAllMyBuckets"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

data "aws_iam_policy_document" "github_cicd_assume_role_policy" {
  statement {
    sid    = "AllowGithubActionsAssumeRole"
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [ aws_iam_openid_connect_provider.github_cicd_idp.arn ]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = [ var.github_cicd_client_id ]
    }

    condition {
      test = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = var.github_cicd_repos_with_env
    }
  }
}
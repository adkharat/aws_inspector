module "kms" {
  source              = "./module/aws_kms_key"
  kms_key_description = var.ebs_kms_description
  kms_key_key_usage   = var.ebs_kms_key_usage
  enable_key_rotation = true
  aws_kms_key_policy = jsonencode({
    "Id" : "key-consolepolicy-3",
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "Allow access for Key Administrators",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::602304653960:role/MyAWSServiceRoleForImageBuilder",
            "arn:aws:iam::602304653960:root",
            "arn:aws:iam::211125510693:root",
          ]
        },
        "Action" : [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion",
          "kms:ReplicateKey",
          "kms:UpdatePrimaryRegion",
          "kms:RotateKeyOnDemand"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow use of the key",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::602304653960:role/MyAWSServiceRoleForImageBuilder",
            "arn:aws:iam::602304653960:root",
            "arn:aws:iam::211125510693:root"
          ]
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow attachment of persistent resources",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::602304653960:role/MyAWSServiceRoleForImageBuilder",
            "arn:aws:iam::602304653960:root",
            "arn:aws:iam::211125510693:root"
          ]
        },
        "Action" : [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ],
        "Resource" : "*",
        "Condition" : {
          "Bool" : {
            "kms:GrantIsForAWSResource" : "true"
          }
        }
      }
    ]
    }
  )
  multi_region = true
}

module "kms_alias" {
  depends_on = [module.kms]

  source            = "./module/aws_kms_alias"
  kms_alias_name    = "alias/golden-kms-key-alias"
  target_kms_key_id = module.kms.key_id
}

//region = "us-east-2"
# module "kms_replica_key" {
#   source = "./module/aws_kms_replica_key"
#   primary_key_arn = module.kms.arn
# }

# data "aws_iam_policy_document" "key_policy" {
#   statement {
#       sid = "Enable IAM User Permissions"
#       effect = "Allow"
#       principals {
#         type        = "AWS"
#         identifiers = ["*"]
#       }
#       actions = [
#         "kms:*"
#       ]
#       resources = [module.kms.arn]
#     }

#   statement {
#     sid = "Allow access for Key Administrators"
#     effect = "Allow"
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#     actions = [
#           "kms:Create*",
#           "kms:Describe*",
#           "kms:Enable*",
#           "kms:List*",
#           "kms:Put*",
#           "kms:Update*",
#           "kms:Revoke*",
#           "kms:Disable*",
#           "kms:Get*",
#           "kms:Delete*",
#           "kms:TagResource",
#           "kms:UntagResource",
#           "kms:ScheduleKeyDeletion",
#           "kms:CancelKeyDeletion",
#           "kms:ReplicateKey",
#           "kms:UpdatePrimaryRegion",
#           "kms:RotateKeyOnDemand"
#     ]
#     resources = [module.kms.arn]
#     condition {
#       test     = "StringEquals"
#       variable = "AWS:PrincipalOrgID"
#       values   = ["o-Oyouih5jt4"]
#     }
#     condition {
#       test     = "BoolIfExists"
#       variable = "AWS:PrincipalIsAWSService"
#       values   = ["true"]
#     }
#   }

#   statement {
#     sid = "Allow use of the key"
#     effect = "Allow"
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#     actions = [
#           "kms:Encrypt",
#           "kms:Decrypt",
#           "kms:ReEncrypt*",
#           "kms:GenerateDataKey*",
#           "kms:DescribeKey"
#     ]
#     resources = [module.kms.arn]
#     condition {
#       test     = "StringEquals"
#       variable = "AWS:PrincipalOrgID"
#       values   = ["o-Oyouih5jt4"]
#     }
#     condition {
#       test     = "BoolIfExists"
#       variable = "AWS:PrincipalIsAWSService"
#       values   = ["true"]
#     }
#   }

#   statement {
#     sid = "Allow attachment of persistent resources"
#     effect = "Allow"
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#     actions = [
#            "kms:CreateGrant",
#            "kms:ListGrants",
#            "kms:RevokeGrant"
#     ]
#     resources = [module.kms.arn]
#     condition {
#       test     = "StringEquals"
#       variable = "AWS:PrincipalOrgID"
#       values   = ["o-Oyouih5jt4"]
#     }
#     condition {
#       test     = "BoolIfExists"
#       variable = "AWS:PrincipalIsAWSService"
#       values   = ["true"]
#     }
#     condition {
#       test     = "Bool"
#       variable = "kms:GrantIsForAWSResource"
#       values   = ["true"]
#     }
#   }
# }

# module "kms_key_policy" {
#   source = "./module/aws_kms_key_policy"
#   depends_on = [module.kms]
#   key_id = module.kms.key_id
#   policy_json = data.aws_iam_policy_document.key_policy.json
# }

# module "kms_key_policy" {
#   source = "./module/aws_kms_key_policy"
#   depends_on = [module.kms]
#   key_id = module.kms.key_id
#   policy_json = jsonencode({
#     Id = "example"
#     Statement = [
#       {
#         Sid      = "Enable IAM User Permissions"
#         Action = "kms:*"
#         Effect = "Allow"
#         Principal = "*"
#         Resource = module.kms.arn
#       },
#       {
#         Sid      = "Allow access for Key Administrators"
#         Action = [
#           "kms:Create*",
#           "kms:Describe*",
#           "kms:Enable*",
#           "kms:List*",
#           "kms:Put*",
#           "kms:Update*",
#           "kms:Revoke*",
#           "kms:Disable*",
#           "kms:Get*",
#           "kms:Delete*",
#           "kms:TagResource",
#           "kms:UntagResource",
#           "kms:ScheduleKeyDeletion",
#           "kms:CancelKeyDeletion",
#           "kms:ReplicateKey",
#           "kms:UpdatePrimaryRegion",
#           "kms:RotateKeyOnDemand"
#         ],
#         Effect = "Allow"
#         Principal = "*"
#         Resource = module.kms.arn
#       },
#       {
#         Sid      = "Allow use of the key"
#         Action = [
#           "kms:Encrypt",
#           "kms:Decrypt",
#           "kms:ReEncrypt*",
#           "kms:GenerateDataKey*",
#           "kms:DescribeKey"
#         ]
#         Effect = "Allow"
#         Principal = "*"
#         Resource = module.kms.arn
#       },
#       {
#         Sid      = "Allow attachment of persistent resources"
#         Action = [
#            "kms:CreateGrant",
#            "kms:ListGrants",
#            "kms:RevokeGrant"
#         ]
#         Effect = "Allow"
#         Principal = "*"
#         Resource = module.kms.arn
#         Conditions = [
#           {
#             test     = "Bool"
#             variable = "kms:GrantIsForAWSResource"
#             values   = ["true"]
#           }
#         ]
#       },
#     ]
#     Version = "2012-10-17"
#   })
# }
# module "sns_topic" {
#     source = "./module/aws_sns_topic"
#     sns_topic_name = "s3uploadevent"
#     is_fifo_topic = false
#     delivery_policy = <<EOF
#                         {
#                         "http": {
#                             "defaultHealthyRetryPolicy": {
#                             "minDelayTarget": 20,
#                             "maxDelayTarget": 20,
#                             "numRetries": 3,
#                             "numMaxDelayRetries": 0,
#                             "numNoDelayRetries": 0,
#                             "numMinDelayRetries": 0,
#                             "backoffFunction": "linear"
#                             },
#                             "disableSubscriptionOverrides": false,
#                             "defaultRequestPolicy": {
#                             "headerContentType": "text/plain; charset=UTF-8"
#                             }
#                         }
#                         }
#                         EOF

#     # policy = jsonencode("./sns_policy.json")

#     policy = <<EOF
#     {
#     "Version": "2012-10-17",
#     "Id": "sns-policy",
#     "Statement": [
#         {
#             "Sid": "Example SNS topic policy",
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "s3.amazonaws.com"
#             },
#             "Action": [
#                 "SNS:GetTopicAttributes",
#                 "SNS:SetTopicAttributes",
#                 "SNS:AddPermission",
#                 "SNS:RemovePermission",
#                 "SNS:DeleteTopic",
#                 "SNS:Subscribe",
#                 "SNS:ListSubscriptionsByTopic",
#                 "SNS:Publish"
#             ],
#             "Resource": "arn:aws:sns:us-east-1:602304653960:s3uploadevent",
#             "Condition": {
#                 "ArnLike": {
#                     "aws:SourceArn": "arn:aws:s3:::inspectorscaningfile"
#                 },
#                 "StringEquals": {
#                     "aws:SourceAccount": "602304653960"
#                 }
#             }
#         }
#     ]
#     }
#     EOF

#     tags = {
#         "Name" = "S3CSVuploadevent"
#     }
# }

# # data "aws_iam_policy_document" "sns_topic_policy" {
# #     policy_id = "__default_policy_ID"

# #     statement {
# #     actions = [
# #       "SNS:Subscribe",
# #       "SNS:SetTopicAttributes",
# #       "SNS:RemovePermission",
# #       "SNS:Receive",
# #       "SNS:Publish",
# #       "SNS:ListSubscriptionsByTopic",
# #       "SNS:GetTopicAttributes",
# #       "SNS:DeleteTopic",
# #       "SNS:AddPermission",
# #     ]

# #     condition {
# #       test     = "StringEquals"
# #       variable = "aws:SourceOwner"

# #       values = [
# #         data.aws_caller_identity.current.account_id
# #       ]
# #     }

# #     condition {
# #       test     = "ArnLike"
# #       variable = "aws:SourceArn"

# #       values = [
# #         module.inspectorscaningfile.arn
# #       ]
# #     }

# #     effect = "Allow"

# #     principals {
# #       type        = "AWS"
# #       identifiers = ["*"]
# #     }

# #     resources = [
# #       module.sns_topic.arn,
# #     ]

# #     sid = "__default_statement_ID"
# #   }

# # }

# # data "aws_iam_policy_document" "sns_topic_policy" {
# #   "Version": "2012-10-17",
# #   "Id": "example-ID",
# #   "Statement": [
# #     {
# #       "Sid": "Example SNS topic policy",
# #       "Effect": "Allow",
# #       "Principal": {
# #         "Service": "s3.amazonaws.com"
# #       },
# #       "Action": [
# #         "SNS:Publish"
# #       ],
# #       "Resource": "SNS-topic-ARN",
# #       "Condition": {
# #         "ArnLike": {
# #           "aws:SourceArn": "arn:aws:s3:*:*:bucket-name"
# #         },
# #         "StringEquals": {
# #           "aws:SourceAccount": "bucket-owner-account-id"
# #         }
# #       }
# #     }
# #   ]
# # }

# # module "sns_policy" {
# #   source = "./module/aws_sns_topic_policy"
# #   sns_topic_arn = module.sns_topic.arn
# #   sns_policy = data.aws_iam_policy_document.sns_topic_policy.json
# # }

# module "s3_bucket_notification" {
#   depends_on = [ module.inspectorscaningfile, module.sns_topic ]
#   source = "./module/aws_s3_bucket_notification"
#   s3bucket_id = module.inspectorscaningfile.id
#   s3_event_notification_topic_arn = module.sns_topic.arn
# }

# module "topic_email_subscription" {
#   source = "./module/aws_sns_topic_subscription"
#   email_address = var.email_address
#   topic_arn = module.sns_topic.arn
# }
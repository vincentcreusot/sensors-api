#--iot/main--
#AWS-IoT-Thing
resource "aws_iot_thing" "iot_core" {
  name = "picow-bme680"
}

resource "aws_iot_thing_principal_attachment" "iot_attachment" {
  principal = aws_iot_certificate.iot_certificate.arn
  thing = aws_iot_thing.iot_core.name
}

resource "aws_iot_topic_rule" "iot_rule" {
  name = "iot_rule"
  sql = "SELECT * FROM 'topic/temperature'"
  sql_version = "2016-03-23"
  enabled     = true
  description = "Send data from the AWS IoT Core to AWS Timestream"

  timestream {
    database_name = aws_timestreamwrite_database.timestream_database.database_name

    dimension {
      name = "temperature"
      value = "DOUBLE"
    }
    dimension {
      name = "humidity"
      value = "DOUBLE"
    }
    dimension {
      name = "pressure"
      value = "DOUBLE"
    }
    dimension {
      name = "gas"
      value = "DOUBLE"
    }
    dimension {
      name = "altitude"
      value = "DOUBLE"
    }

    table_name = aws_timestreamwrite_table.timestream_table.table_name
    role_arn = aws_iam_role.iot_role.arn
  }

}

resource "aws_iot_policy" "iot_timestream_policy" {
  name = "iot-timestream-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "timestream:WriteRecords"
        ]
        Resource = [
          "${aws_timestreamwrite_database.timestream_database.arn}"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "iot:Connect",
          "iot:Subscribe"
        ],
        "Resource": "arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "iot:Publish"
        ],
        "Resource": "arn:aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:topic/temperature"
      }
    ]
  })
}

resource "aws_iot_policy_attachment" "iot_policy_attachment" {
  policy = aws_iot_policy.iot_timestream_policy.name
  target = aws_iot_certificate.iot_certificate.arn
}
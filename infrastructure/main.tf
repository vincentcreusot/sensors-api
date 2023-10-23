terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
#  profile = "p-admin"
}

resource "aws_timestreamwrite_database" "timestream_database" {
  database_name = "timestream-database-iot"

  tags = {
    Name = "timestream-database-iot"
    label = "iot-sensors-db"
  }
}

resource "aws_timestreamwrite_table" "timestream_table" {
  database_name = aws_timestreamwrite_database.timestream_database.database_name
  table_name = "timestream-database-iot-table"
}
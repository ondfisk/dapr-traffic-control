terraform {
  backend "azurerm" {
    resource_group_name  = "ondfisk"
    storage_account_name = "ondfisk"
    container_name       = "dapr-traffic-control-aws"
    key                  = "prod.terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-north-1"
}

variable "table_name" {
  type = string
}

variable "queue_name" {
  type = string
}

variable "dead_letters_queue_name" {
  type = string
}

variable "fine_calculator_license_key_secret_name" {
  type = string
}

variable "fine_calculator_license_key" {
  type = string
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "key"
  attribute {
    name = "key"
    type = "S"
  }
}

resource "aws_sqs_queue" "queue" {
  name = var.queue_name
}

resource "aws_sqs_queue" "deadletter_queue" {
  name = var.dead_letters_queue_name
}

resource "aws_secretsmanager_secret" "secret" {
  name = var.fine_calculator_license_key_secret_name
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = var.fine_calculator_license_key
}
locals {
  tags = merge(
    {
      Project = var.project_name
    },
    var.tags,
  )
}

resource "aws_sqs_queue" "dlq" {
  count = var.dlq_enabled ? 1 : 0

  name                        = "${var.queue_name}-dlq"
  message_retention_seconds   = var.dlq_message_retention_seconds
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.fifo_queue ? var.content_based_deduplication : null
  kms_master_key_id           = var.kms_master_key_id

  tags = merge(
    local.tags,
    {
      Name = "${var.queue_name}-dlq"
    },
  )
}

resource "aws_sqs_queue" "this" {
  name                        = var.queue_name
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.fifo_queue ? var.content_based_deduplication : null
  delay_seconds               = var.delay_seconds
  max_message_size            = var.max_message_size
  message_retention_seconds   = var.message_retention_seconds
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  visibility_timeout_seconds  = var.visibility_timeout_seconds
  kms_master_key_id           = var.kms_master_key_id

  redrive_policy = var.dlq_enabled ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.dlq_max_receive_count
  }) : null

  tags = merge(
    local.tags,
    {
      Name = var.queue_name
    },
  )
}

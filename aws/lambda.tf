data "archive_file" "lambda-edge" {
  type        = "zip"
  source_dir  = "${path.module}/lambda-edge/src"
  output_path = "${path.module}/lambda-edge/dest/lambda-edige-router.zip"
}

resource "aws_lambda_function" "lambda-edge-router" {
  provider         = aws.virginia
  filename         = data.archive_file.lambda-edge.output_path
  function_name    = "${var.prefix}lambda-edge-router"
  role             = aws_iam_role.lambda-edge-role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda-edge.output_base64sha256
  runtime          = "nodejs12.x"
  publish          = true

  memory_size = 128
  timeout     = 3
}

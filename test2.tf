provider "docker" {
  version = "~> 2.6"
}

provider "aws" {
  version                     = "~> 2.46"
  access_key                  = "mock_access_key"
  region                      = "us-east-1"
  s3_force_path_style         = true
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localhost:4567"
    lambda         = "http://localhost:4574"
    s3             = "http://localhost:4572"
    cloudformation = "http://localhost:4581"
    ssm            = "http://localhost:4583"
    sts            = "http://localhost:4592"
  }
}

resource "docker_container" "ciDB" {
  name  = "ciDB"
  image = "usgswma/wqp_db:ci"
  ports {
    internal = 5432
    external = 5435
  }
}

resource "docker_network" "lambdanet" {
  name = "lambdanet"
  ipam_config {
    gateway = "192.168.0.1"
    subnet  = "192.168.0.0/24"
  }
  ipam_driver = "default"
}

resource "docker_container" "localStack" {
  depends_on = [docker_network.lambdanet]
  name       = "localstack_demo"
  image      = "localstack/localstack"
  ports {
    internal = 4567
    external = 4567
  }
  ports {
    internal = 4572
    external = 4572
  }
  ports {
    internal = 4574
    external = 4574
  }
  ports {
    internal = 4581
    external = 4581
  }
  ports {
    internal = 4583
    external = 4583
  }
  ports {
    internal = 4592
    external = 4592
  }
  ports {
    internal = 8080
    external = 8080
  }

  env = [
    "DEFAULT_REGION=us-east-1",
    "AWS_XRAY_SDK_ENABLED=true",
    "LAMBDA_EXECUTOR=docker",
    "LAMBDA_REMOTE_DOCKER=false",
    "DOCKER_HOST=unix:///var/run/docker.sock"
  ]
  volumes {
    host_path      = "/tmp/localstack"
    container_path = "/tmp/localstack"
  }
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }
  networks_advanced {
    name = "lambdanet"
  }
    healthcheck {
      test = ["CMD",
	 "bash",
	 "-c",
	 "awslocal ssm describe-parameters && awslocal s3 ls"
]
      interval = "20s"
      timeout = "10s"
      start_period = "10s"
}
must_run = true
  provisioner "local-exec" {
    command = "./bin/health-check"
  }
}

resource "aws_ssm_parameter" "parms" {
  depends_on = [docker_container.localStack]
  for_each = {
    "/iow/wqp/local/database/host" = "192.168.0.1"
    "/iow/wqp/local/database/name" = "wqp_db"
    "/iow/wqp/local/database/user" = "wqp_user"
  }
  name = each.key
  value = each.value
  type = "String"
}

resource "aws_ssm_parameter" "secrets" {
  depends_on = [docker_container.localStack]
  for_each = {
    "/aws/reference/secretsmanager/WQP_DB_READ_ONLY_PASSWORD-local" = "changeMe"
  }
  name = each.key
  value = each.value
  type = "SecureString"
}

resource "aws_s3_bucket" "b" {
  depends_on    = [docker_container.localStack]
  bucket        = "iow-cloud-applications"
  acl           = "public-read"
  force_destroy = true
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


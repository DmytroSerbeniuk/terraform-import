# module "cluster" {
#   source                       = "terraform-aws-modules/rds-aurora/aws"
#   version                      = "8.3.1"
#   name                         = "test-aurora-db-postgres96"
#   engine                       = "aurora-postgresql"
#   engine_version               = "14.5"
#   instance_class               = "db.t3.medium"
#   master_username              = local.db_creds.username
#   master_password              = local.db_creds.password
#   publicly_accessible          = true
#   final_snapshot_identifier    = true
#   preferred_backup_window      = "02:00-03:00"
#   preferred_maintenance_window = "sun:05:00-sun:06:00"
#   instances = {
#     1 = {
#       instance_class      = "db.t3.medium"
#       publicly_accessible = true
#     }
#   }
#   vpc_id               = module.vpc.vpc_id
#   db_subnet_group_name = module.vpc.database_subnet_group_name
#   security_group_rules = {
#     vpc_ingress = {
#       cidr_blocks = ["0.0.0.0/0", "223.234.189.31/32"]
#     }
#     egress_example = {
#       cidr_blocks = ["10.99.0.0/18"]
#       description = "Egress to corporate printer closet"
#     }
#   }

#   storage_encrypted               = true
#   apply_immediately               = true
#   monitoring_interval             = 10
#   enabled_cloudwatch_logs_exports = ["postgresql"]

#   tags = {
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }

# # Firstly create a random generated password to use in secrets.

# resource "random_password" "password" {
#   length           = 16
#   special          = true
#   override_special = "_%@"
# }

# # Creating a AWS secret for database master account (Masteraccoundb)

# resource "aws_secretsmanager_secret" "secretmasterDB" {
#   name        = "Masteraccoundb"
#   description = "Create pass auroradb"
#   tags = {
#     Name = "auroradb"
#   }
# }

# # Creating a AWS secret versions for database master account (Masteraccoundb)

# resource "aws_secretsmanager_secret_version" "version" {
#   secret_id     = aws_secretsmanager_secret.secretmasterDB.id
#   secret_string = <<EOF
#    {
#     "username": "adminaccount",
#     "password": "${random_password.password.result}"
#    }
# EOF
# }

# # Importing the AWS secrets created previously using arn.

# data "aws_secretsmanager_secret" "secretmasterDB" {
#   arn = aws_secretsmanager_secret.secretmasterDB.arn
# }

# # Importing the AWS secret version created previously using arn.

# data "aws_secretsmanager_secret_version" "creds" {
#   secret_id = data.aws_secretsmanager_secret.secretmasterDB.arn
# }

# # After importing the secrets storing into Locals

# locals {
#   db_creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)
# }
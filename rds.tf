# module "db" {
#   source                              = "terraform-aws-modules/rds/aws"
#   version                             = "6.1.0"
#   identifier                          = "demodb"
#   engine                              = "mysql"
#   engine_version                      = "5.7"
#   instance_class                      = "db.t3.micro"
#   allocated_storage                   = 5
#   db_name                             = "demodb"
#   username                            = "admin"
#   publicly_accessible                 = true
#   password                            = data.aws_ssm_parameter.my_rds_password.value
#   port                                = "3306"
#   iam_database_authentication_enabled = true
#   vpc_security_group_ids              = ["${aws_security_group.rds_sg.id}"]
#   maintenance_window                  = "Mon:00:00-Mon:03:00"
#   backup_window                       = "03:00-06:00"
#   monitoring_interval                 = "30"
#   monitoring_role_name                = "MyRDSMonitoringRole"
#   create_monitoring_role              = true
#   create_db_subnet_group              = true
#   multi_az                            = false
#   subnet_ids                          = module.vpc.public_subnets
#   family                              = "mysql5.7"
#   major_engine_version                = "5.7"

#   tags = {
#     Owner       = "user"
#     Environment = "dev"
#   }


#   parameters = [
#     {
#       name  = "character_set_client"
#       value = "utf8mb4"
#     },
#     {
#       name  = "character_set_server"
#       value = "utf8mb4"
#     }
#   ]

#   options = [
#     {
#       option_name = "MARIADB_AUDIT_PLUGIN"

#       option_settings = [
#         {
#           name  = "SERVER_AUDIT_EVENTS"
#           value = "CONNECT"
#         },
#         {
#           name  = "SERVER_AUDIT_FILE_ROTATIONS"
#           value = "37"
#         },
#       ]
#     },
#   ]
# }

# # // Generate Password  # vpc_security_group_ids              = [module.security_group.security_group_id] EghEv7AAEmQoy0ufTIpX
# resource "random_string" "rds_password" {
#   length           = 16
#   special          = false
#   # override_special = "!#$&"

# }

# // Get Password from SSM Parameter Store
# data "aws_ssm_parameter" "my_rds_password" {
#   name = "/production/database/password/master"
#   # depends_on = [aws_ssm_parameter.rds_password]
# }

# output "re" {
#   value = aws_ssm_parameter.secret
#   sensitive = true
# }

# resource "aws_ssm_parameter" "secret" {
#   name        = "/production/database/password/master"
#   description = "The parameter description"
#   type        = "SecureString"
#   value       = random_string.rds_password.result

#   tags = {
#     environment = "production"
#   }
# }

# #create a security group for RDS Database Instance
# resource "aws_security_group" "rds_sg" {
#   vpc_id = module.vpc.vpc_id
#   name   = "rds_sg"
#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # module "security_group" {
# #   source  = "terraform-aws-modules/security-group/aws"
# #   version = "~> 3"

# #   name        = "${local.name}-sg"
# #   description = "MySQL security group"
# #   vpc_id      = module.vpc.vpc_id

# #   # ingress
# #   ingress_with_cidr_blocks = [
# #     {
# #       from_port   = 3306
# #       to_port     = 3306
# #       protocol    = "tcp"
# #       description = "MySQL access from within VPC"
# #       cidr_blocks = module.vpc.vpc_cidr_block
# #     },
# #   ]

# #   tags = {
# #     Project = "Yeew"
# #   }
# # }

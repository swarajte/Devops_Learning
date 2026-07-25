locals {

  instance_name = "${var.environment}-${var.project_name}-server"

  instance_type = var.environment == "prod" ? "t3.large" : "t3.micro"

  owner = var.environment == "prod" ? "DevOps Team" : "Developers"

  project_upper = upper(var.project_name)
 
  is_production = var.environment == "prod"
}

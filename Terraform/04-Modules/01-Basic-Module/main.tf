module "greeting" {

  source = "./modules/greeting"

}

output "module_message" {
  value = module.greeting.message
}

// passed in to the module via a "providers" block:
provider "aws" {
  alias = "cloudfront"
}

module "ci_user" {
  source = "github.com/openoakland/terraform-modules//eb_deploy_user?ref=v2.2.0"

  eb_deploy_username = "oakcrime-ci"
}

module "app_oakcrime" {
  source = "github.com/openoakland/terraform-modules//beanstalk_app?ref=v2.2.0"

  app_name = "oakcrime"
}

module "db_production" {
  source = "github.com/openoakland/terraform-modules//postgresdb?ref=v2.2.0"

  db_engine_version = "10.6"
  db_name     = "oakcrime"
  db_password = var.prod_db_password
  db_username = "oakcrime"
  namespace   = "oakcrime-production"
}

module "env_web_production" {
  source = "github.com/openoakland/terraform-modules//beanstalk_web_env?ref=v2.2.0"

  app_instance = "prod-web"
  app_name     = "oakcrime"
  dns_zone     = "aws.openoakland.org"
  key_pair     = "oakcrime"
  security_groups = [module.db_production.security_group_name]

  environment_variables = {
    BOX_CLIENT_ID       = var.prod_box_client_id
    BOX_CLIENT_SECRET   = var.prod_box_client_secret
    BOX_ENTERPRISE_ID   = var.prod_box_enterprise_id
    BOX_PASS_PHRASE     = var.prod_box_pass_phrase
    BOX_PUBLIC_KEY_ID   = var.prod_box_public_key_id
    BOX_RSA_KEY         = var.prod_box_rsa_key
    DATABASE_URL        = module.db_production.postgis_database_url
    EMAIL_URL           = "smtp://localhost"
    GOOGLE_MAPS_API_KEY = var.prod_google_maps_api_key
    SECRET_KEY          = var.prod_django_secret_key
    SERVER_EMAIL        = "root@localhost"
  }
}

module "env_worker_production" {
  source = "github.com/openoakland/terraform-modules//beanstalk_worker_env?ref=v2.2.0"

  app_instance = "production"
  app_name     = "oakcrime"
  key_pair     = "oakcrime"
  name         = "oakcrime-production-worker"
  security_groups = [module.db_production.security_group_name]

  environment_variables = {
    BOX_CLIENT_ID       = var.prod_box_client_id
    BOX_CLIENT_SECRET   = var.prod_box_client_secret
    BOX_ENTERPRISE_ID   = var.prod_box_enterprise_id
    BOX_PASS_PHRASE     = var.prod_box_pass_phrase
    BOX_PUBLIC_KEY_ID   = var.prod_box_public_key_id
    BOX_RSA_KEY         = var.prod_box_rsa_key
    DATABASE_URL        = module.db_production.postgis_database_url
    EMAIL_URL           = "smtp://localhost"
    GOOGLE_MAPS_API_KEY = var.prod_google_maps_api_key
    OAKCRIME_WORKER     = "1"
    SECRET_KEY          = var.prod_django_secret_key
    SERVER_EMAIL        = "root@localhost"
    SOCRATA_KEY         = var.prod_socrata_key
  }
}

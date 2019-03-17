module "ci_user" {
  source = "github.com/openoakland/terraform-modules//eb_deploy_user?ref=v2.0.0"

  eb_deploy_username = "oakcrime-ci"
}

module "app_oakcrime" {
  source = "github.com/openoakland/terraform-modules//beanstalk_app?ref=v2.0.0"

  app_name = "oakcrime"
}

module "db_production" {
  source = "github.com/openoakland/terraform-modules//postgresdb?ref=v2.0.1"

  db_engine_version = "10.6"
  db_name     = "oakcrime"
  db_password = "${var.prod_db_password}"
  db_username = "oakcrime"
  namespace   = "oakcrime-production"
}

module "env_web_production" {
  source = "github.com/openoakland/terraform-modules//beanstalk_web_env?ref=v2.0.0"

  app_instance = "prod-web"
  app_name     = "oakcrime"
  dns_zone     = "aws.openoakland.org"
  key_pair     = "oakcrime"

  environment_variables = {
    DATABASE_URL = "${module.db_production.postgis_database_url}"
    EMAIL_URL    = "smtp://localhost"
    SECRET_KEY   = "${var.prod_django_secret_key}"
    SERVER_EMAIL = "root@localhost"
  }
}

module "env_worker_production" {
  source = "github.com/openoakland/terraform-modules//beanstalk_worker_env?ref=worker-environment"

  app_instance = "production"
  app_name     = "oakcrime"
  key_pair     = "oakcrime"
  name         = "oakcrime-production-worker"

  environment_variables = {
    DATABASE_URL = "${module.db_production.postgis_database_url}"
    EMAIL_URL    = "smtp://localhost"
    SECRET_KEY   = "${var.prod_django_secret_key}"
    SERVER_EMAIL = "root@localhost"
  }
}

#----root/main.tf-----
provider "aws" {
  region = "${var.aws_region}"
}

# Deploy Storage Resources
module "storage" {
  source       = "./storage"
  project_name = "${var.project_name}"
}

# Deploy Networking Resources
module "networking" {
  source       = "./networking"
  vpc_cidr     = "${var.vpc_cidr}"
  public_cidrs = "${var.public_cidrs}"
  accessip     = "${var.accessip}"
}

# Deploy Compute Resources
module "compute" {
  source          = "./compute"
  instance_count  = "${var.instance_count}"
  key_name        = "${var.key_name}"
  public_key_path = "${var.public_key_path}"
  instance_type   = "${var.server_instance_type}"
  subnets         = "${module.networking.public_subnets}"
  security_group  = "${module.networking.public_sg}"
  subnet_ips      = "${module.networking.subnet_ips}"
}

module "alb" {
  source              = "./alb"
  vpc_id              = "${module.networking.vpc_id}"
  instance1_id        = "${module.compute.instance1_id}"
  instance2_id        = "${module.compute.instance2_id}"
  subnet1             = "${module.networking.subnet1}"
  subnet2             = "${module.networking.subnet2}"
  security_group_id   = "${module.networking.public_sg}"
}

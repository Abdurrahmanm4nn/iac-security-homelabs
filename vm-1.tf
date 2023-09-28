module "gce-vm" {
  source = "./modules/gce"
  name         = "terraform-vm-1"
  gce_instance = "e2-micro"
  image_os     = "debian-cloud/debian-11"
  vpc_network  = module.vpc-network.vpc_name

  depends_on = [module.vpc-network]
}
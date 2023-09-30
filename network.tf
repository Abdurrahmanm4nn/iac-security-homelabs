module "vpc-network" {
  source   = "./modules/vpc-network"
  vpc_name = "terraform-vpc"
}

module "vpc-subnet" {
  source      = "./modules/vpc-subnet"
  subnet_name = "terraform-subnet"
  region      = var.region
  cidr_range  = "10.10.0.0/24"
  vpc_name    = "terraform-vpc"

  depends_on = [module.vpc-network]
}
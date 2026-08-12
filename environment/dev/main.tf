module "rgs" {
  source = "../../modules/resource_group"
  rgs    = var.rgs

} 
 
 

module "vnets" {
  depends_on = [module.rgs]
  source     = "../../modules/virtual_network"
  vnets      = var.vnets
}

module "subnets" {
  depends_on = [module.vnets]
  source     = "../../modules/subnet"
  subnets    = var.subnets
}

module "pips" {
  depends_on = [module.rgs]
  source     = "../../modules/pip"
  pips       = var.pips
}

module "nsgs" {
  depends_on = [module.rgs]
  source     = "../../modules/nsg"
  nsgs       = var.nsgs
}

module "kvs" {
  depends_on = [module.rgs]
  source     = "../../modules/key_vault"
  kvs        = var.kvs
}

module "bastions" {
  depends_on = [module.subnets]
  source     = "../../modules/azure_bastion"
  bastion    = var.bastions
}

module "appgws" {
  depends_on = [module.subnets, module.pips, module.nsgs]
  source     = "../../modules/application_gateway"
  AGW        = var.appgws
}

module "vms" {
  depends_on = [module.subnets, module.nsgs]
  source     = "../../modules/virtual_machine"
  vms        = var.vms
}
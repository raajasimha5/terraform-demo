provider "google"{
project= var.gcp_project_id
region= var.gcp_region
    }

module "compute" {
source= "./modules/compute-module"
gcp_project_id= var.gcp_project_id
gcp_region= var.gcp_region
gcp_zone= var.gcp_zone
vm_instance_count= var.vm_instance_count
vm_instance_name= var.vm_instance_name
vm_machine_type= var.vm_machine_type
vm_image= var.vm_image
network_name= module.vpc.vpc_network_name
}

module "vpc"{
source= "./modules/vpc-module"
gcp_project_id= var.gcp_project_id
vpc_name= var.vpc_name
auto_create_subnetworks= var.auto_create_subnetworks
    }
##input for vpc##
 
auto_create_subnetworks=true
vpc_name="my-custom-vpc"
gcp_project_id="smiling-breaker-325908"
 
 
## inputs for vm module##

gcp_region           = "us-central1"
gcp_zone             = "us-central1-a"
vm_instance_count    = 1
vm_instance_name     = "rsv-vm"
vm_machine_type      = "e2-small"
vm_image             = "debian-cloud/debian-11"
network_name         = "rsv-network"
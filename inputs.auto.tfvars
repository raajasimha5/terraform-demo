
# Provider / Global Settings
project_id = "smiling-breaker-325908"
region     = "asia-south1"
zone       = "asia-south1-b"

# Network Settings
network_name = "private-vp1"
subnet_cidr  = "10.10.0.0/24"

# Module Inputs
router_name    = "private-route1"
nat_name       = "private-nat1"
name_prefix    = "private-lb1" # This prefix is used for the LB, MIG, etc.
machine_type   = "e2-micro"
instance_count = 2

# Instance tags (must include lb-backend for LB traffic and ssh-iap for IAP SSH)
vm_tags = ["lb-backend", "ssh-iap"]

## Debian image details 
image_family = "debian-12"
image_project = "debian-cloud"


terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "< 4.0.0"
    }
  }

  backend "gcs" {
    bucket = "eq-ex-petclinic-tf"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "infra-instance" {
  name          = "infra-instance"
  machine_type  = "n2-standard-2"
  tags          = ["bastion"]

  boot_disk {    
    device_name = "eq-ex-infra-disk"
    initialize_params {
      image = "debian-cloud/debian-10"
      size = "50"
    }
  }

  network_interface {
    network     = var.network_name
    subnetwork  = "public-subnet"
    access_config {
    }
  }

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  metadata_startup_script = "${file(var.instance_startup_script)}"
}

resource "google_compute_instance" "app-instance" {
  name          = "app-instance"
  machine_type  = "n2-standard-2"
  tags          = ["application"]

  boot_disk {    
    device_name = "eq-ex-app-disk"
    initialize_params {
      image = "debian-cloud/debian-10"
      size = "50"
    }
  }

  network_interface {
    network     = var.network_name
    subnetwork  = "private-subnet"
  }

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

}

module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 3.0"

    project_id   = var.project
    network_name = var.network_name
    routing_mode = var.routing_mode

    subnets = [
        {
            subnet_name           = "public-subnet"
            subnet_ip             = "172.20.10.0/24"
            subnet_region         = var.region
        },
        {
            subnet_name           = "private-subnet"
            subnet_ip             = "172.20.20.0/24"
            subnet_region         = var.region
            subnet_private_access = "true"
        }
    ]

    routes = [
        {
            name                   = "egress-internet"
            description            = "route through IGW to access internet"
            destination_range      = "0.0.0.0/0"
            tags                   = "egress-inet"
            next_hop_internet      = "true"
        }
    ]
}

module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.4"
  project = var.project
  name    = "my-cloud-router"
  network = var.network_name
  region  = var.region

  nats = [{
    name = "my-nat-gateway"
  }]
}

resource "google_compute_firewall" "ingress-ssh-into-bastion-fw" {
  name    = "allow-ssh-into-bastion"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["22", "8080"]
    # ports    = ["22", "80", "8080", "1000-2000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]
  direction     = "INGRESS"
}

resource "google_compute_firewall" "ingress-from-infra-to-app-fw" {
  name    = "allow-from-infra-to-app"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "8080", "1000-2000"]
  }

  source_tags = ["bastion"]  
  target_tags = ["application"]
  direction   = "INGRESS"
}
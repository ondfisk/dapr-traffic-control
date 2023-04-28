terraform {
  backend "azurerm" {
    resource_group_name  = "ondfisk"
    storage_account_name = "ondfisk"
    container_name       = "dapr-traffic-control-google-cloud"
    key                  = "prod.terraform.tfstate"
  }
}

provider "google" {
  project = "dapr-traffic-control-385112"
}

variable "location" {
  type = string
}

variable "pubsub_topic" {
  type = string
}

variable "pubsub_dead_letters_topic" {
  type = string
}

variable "fine_calculator_license_key_secret_id" {
  type = string
}

variable "fine_calculator_license_key" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_location" {
  type = string
}

resource "google_project_service" "firestore" {
  service = "firestore.googleapis.com"
}

resource "google_firestore_database" "datastore_mode_database" {
  name        = "(default)"
  location_id = var.location
  type        = "DATASTORE_MODE"

  depends_on = [google_project_service.firestore]
}

resource "google_pubsub_topic" "pubsub_topic" {
  name = var.pubsub_topic
}

resource "google_pubsub_topic" "pubsub_dead_letters_topic" {
  name = var.pubsub_dead_letters_topic
}

resource "google_secret_manager_secret" "secret" {
  secret_id = var.fine_calculator_license_key_secret_id

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret-version" {
  secret = google_secret_manager_secret.secret.id

  secret_data = var.fine_calculator_license_key
}

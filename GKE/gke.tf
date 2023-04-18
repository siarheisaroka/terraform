resource "google_container_cluster" "primary" {
  project            = var.project
  name               = "cluster1"
  location           = "us-central1-a"
  initial_node_count = var.nodes
  node_config {
    machine_type    = "e2-medium"
    disk_size_gb    = 50
    service_account = data.google_service_account.alchemy.email
    oauth_scopes = ["https://www.googleapis.com/auth/compute"]
    labels = {
      student = "${var.studentname}-${var.studentsurname}"
    }
    tags = [var.studentname, var.studentsurname]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}

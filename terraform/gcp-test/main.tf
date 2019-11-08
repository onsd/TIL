provider "google" {
    credentials = "${file("./credential.json")}"
    project = "${lookup(var.project_name, "${terraform.workspace}")}"
    region = "asia-northeast1"
}

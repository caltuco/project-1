locals {
    resource_name = "${var.project}-${var.global_tags["Environment"]}-${var.cluster_name}"
}
resource "aws_eks_access_entry" "this" {
  cluster_name  = var.cluster_name
  principal_arn = var.principal_arn
  type          = "STANDARD"
  kubernetes_groups = ["portfolio-${var.namespace}-${var.permission_type}"]
  tags          = var.tags
}

resource "kubernetes_namespace_v1" "this" {
  metadata {
    name   = var.namespace
    labels = { "app.kubernetes.io/managed-by" = "terraform" }
  }
}

locals {
  read_rules = [
    { api_groups = [""], resources = ["pods", "services", "endpoints", "configmaps", "events"], verbs = ["get", "list", "watch"] },
    { api_groups = ["apps"], resources = ["deployments", "replicasets", "statefulsets", "daemonsets"], verbs = ["get", "list", "watch"] },
    { api_groups = ["batch"], resources = ["jobs", "cronjobs"], verbs = ["get", "list", "watch"] }
  ]
  write_rules = [
    { api_groups = [""], resources = ["pods", "services", "configmaps", "events"], verbs = ["create", "get", "list", "watch", "update", "patch", "delete"] },
    { api_groups = ["apps"], resources = ["deployments", "replicasets", "statefulsets", "daemonsets"], verbs = ["create", "get", "list", "watch", "update", "patch", "delete"] },
    { api_groups = ["batch"], resources = ["jobs", "cronjobs"], verbs = ["create", "get", "list", "watch", "update", "patch", "delete"] }
  ]
  rules = var.permission_type == "read" ? local.read_rules : var.permission_type == "write" ? local.write_rules : concat(local.read_rules, local.write_rules)
}

resource "kubernetes_role_v1" "this" {
  metadata {
    name      = "team-${var.permission_type}"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
  dynamic "rule" {
    for_each = local.rules
    content {
      api_groups = rule.value.api_groups
      resources  = rule.value.resources
      verbs      = rule.value.verbs
    }
  }
}

resource "kubernetes_role_binding_v1" "this" {
  metadata {
    name      = "team-${var.permission_type}"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.this.metadata[0].name
  }
  subject {
    kind      = "Group"
    name      = "portfolio-${var.namespace}-${var.permission_type}"
    api_group = "rbac.authorization.k8s.io"
  }
}

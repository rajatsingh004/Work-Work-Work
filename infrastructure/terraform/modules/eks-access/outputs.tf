output "namespace" { value = kubernetes_namespace_v1.this.metadata[0].name }
output "access_entry_id" { value = aws_eks_access_entry.this.id }
output "role_name" { value = kubernetes_role_v1.this.metadata[0].name }

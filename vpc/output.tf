output "private_subnets" {
  value = tolist(aws_network_acl.private.subnet_ids)
}
output "public_subnets" {
  value = tolist(aws_network_acl.public.subnet_ids)
}
output "eks_subnets" {
  value = tolist(aws_network_acl.eks.subnet_ids)
}

output "vpc_id" {
  value = aws_vpc.demo.id
}
output "private" {
  value = tolist(aws_network_acl.private.subnet_ids)
}
output "all_private" {
  value = concat ( tolist(aws_network_acl.eks.subnet_ids), tolist(aws_network_acl.private.subnet_ids) )
}

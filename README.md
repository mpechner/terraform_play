# Sample Terraform Project
The repo was original used when I was learning terraform.
Now that I am looking for a job at the moment, 7/22, I'll resurrect this 
repo, and documenting what I did to bring up an AWS environment and working
EKS Cluster.

Will use AWS Provider 4.x and terraform 1.x on OSX into AWS. Will use as much
free resources as possible.

## Terraform installation
Since there are time when you might need more then one version of terraform, 
I install tfenv,
[tfenv repo](https://github.com/tfutils/tfenv)
OSX, I just ran `brew install tfenv`. Just make sure you uninstall previous 
version of terraform. Especially /usr/local/bin/terraform.

## Setup S3 Backing
s3backing sets up the bucket and the dynamodb table.
Once created, add s3backing/backend.tf to add this to the s3backend as well.

## vpc
Reading to make sure setup correctly for EKS:
- https://medium.com/webstep/dont-let-your-eks-clusters-eat-up-all-your-ip-addresses-1519614e9daa
- https://aws.amazon.com/premiumsupport/knowledge-center/eks-multiple-cidr-ranges/
- https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
- https://aws.amazon.com/blogs/containers/optimize-ip-addresses-usage-by-pods-in-your-amazon-eks-cluster/
- https://www.eksworkshop.com/beginner/160_advanced-networking/secondary_cidr/prerequisites/
- https://www.eksworkshop.com/
- 
Public subnets will have access to internet gateway and be allowed public IP 
addresses. Only Load balancers will be allowed in this subnet.

Private subnets will have access to nat gateway and not be allowed public IP 
addresses. There are private blocks per group, priva and privb. The main 
private cidr and the secondary cidr for EKS PODS. 

Primary CIDR 10.0.0.016
Secondary for CNI is 100.64.0.0/16

Created separate NACLs and routes for Public, Private and EKS.
Not yet sure I needed to add separate route table and NACL for EKS.  Will see.

# openvpn
For demo purposes, openvpn same cost as a bastion host.  openvpn is more secure.

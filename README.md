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

# keyPair
First pass, using a pub key on my system. Should Come From Secrets Eventually.
But atleast the keypair is not checked into the code base.

# eks/eks_managed_node_group
Is a modified copy of terraform-aws-modules/terraform-aws-eks/examples/eks_managed_node_group
## Changes
* does not create VPC, uses my VPC Module
* Turned off IPV6
* For initial play and to save money, t3.medium, not M*.larges

Will keep playing. Until I am happy.

# Setting up a private cluster.
For the cluster set
  - cluster_endpoint_private_access = true
  - cluster_endpoint_public_access  = false

The module is not coded well enough to handle a private cluster.
In locals I created additional security groups rules.  For the cluster on port 443 and the node, port 22. 
Instead of self, which is current, the new rules are for the VPN, so CIDR local.priv_cidr, 10.0.0.0/16.
# openvpn
For demo purposes, openvpn same cost as a bastion host.  openvpn is more secure.

Followed this page:

https://aws.amazon.com/blogs/awsmarketplace/setting-up-openvpn-access-server-in-amazon-vpc/

I used the free community 10 license image.

initial ssh:  
ssh openvpnas@…
sudo passwd openvpn - no default password, so just set it.

When connecting via chrome, assxuming you valid cert,
type “thisisunsafe”  type, do not C&P

To save money I stop  after each day's play. The public IP will change 
each time.  
You will need to change IP from the admin UI.  
Then download the profile again.

Do not reserve a public IP, free while in use, costs money to allow 
the public IP to be dynamically allocated when ever you restart the server.
this is for play. Obviously for production, use a resereved IP.

# ToDo
Not complete.
- Before this list is started, look at github actions.
- node H autoscaling
- Pod Scaling
- Logging
  - promethius into Grafana
  - Cloudwatch logging
  - fluentd
  - opensearch
- Load Balancing
  - network
  - application
  - classic - only until network and application is working
- Helm
  - zookeeker - do not need it, but the charts I see make 2888 and 3888 available on the LB. Nuts, that traffic is only requried between the nodes
  - jenkins
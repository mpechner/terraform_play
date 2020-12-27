Just is not there yet. First time playing with EKS.

https://docs.bitnami.com/kubernetes/get-started-eks/

When a cluster is created run:

`eksctl utils associate-iam-oidc-provider --cluster <cluster_name> --approve`

To give you access via kubectl:
`aws eks --region us-east-1 update-kubeconfig --name bitnami-wp`

VPC and subnet tagging:
https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html#vpc-tagging

Networking:
https://docs.aws.amazon.com/eks/latest/userguide/eks-networking.html
Since Nodes tak multiple IP addresses, tjhis will be required reading to fully grok
https://docs.aws.amazon.com/eks/latest/userguide/cni-custom-network.html

eksctl command - this one line does everything this set of plans does:
```
eksctl create cluster \
--name <CLUSTERNAME> \
--version 1.18 \
--region <REGION> \
--nodegroup-name <NODE_GROUP_NAME> \
--nodes <0> \
--nodes-min <0> \
--nodes-max <0> \
--with-oidc \
--ssh-access \
--ssh-public-key <KEYPAIR_NAME> \
--managed \
--instance-types t3.small \
--node-private-networking  \
--vpc-private-subnets <SUBNETID1>,<SUBNETID2>,...
```

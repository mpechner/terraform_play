Just is not there yet. First time playing with EKS.

https://docs.bitnami.com/kubernetes/get-started-eks/

When a cluster is created run:

`eksctl utils associate-iam-oidc-provider --cluster <cluster_name> --approve`

To give you access via kubectl:
`aws eks --region us-east-1 update-kubeconfig --name bitnami-wp`

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

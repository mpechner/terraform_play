MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="//"

--//
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
set -ex
B64_CLUSTER_CA=${cluster_ca}
API_SERVER_URL=${cluster_endpoint)
K8S_CLUSTER_DNS_IP=${dns_ip}
/etc/eks/bootstrap.sh ${cluster_name} --kubelet-extra-args '--node-labels=eks.amazonaws.com/nodegroup-image=${ami},eks.amazonaws.com/capacityType=ON_DEMAND,eks.amazonaws.com/nodegroup=${nodegroup}' --b64-cluster-ca $B64_CLUSTER_CA --apiserver-endpoint $API_SERVER_URL

--//--

/bin/bash /home/ec2-user/config.sh
## Installation of Infrastructure Cluster


- terraform init
- terraform plan
- terraform apply
- terraform output -json > tf.json

## Deploy K8S Cluster with KubeOne

- export HCLOUD_TOKEN="<toke here>"  # For Hetzner Cloud
  For other provider take a loo here: 
  https://docs.kubermatic.com/kubeone/v1.3/tutorials/creating_clusters/#step-5--provisioning-the-cluster

- You need private ssh key now:
  ssh-add ~/.ssh/id_rsa

- kubeone apply -m kubeone.yaml -t tf.json
  
- export ks config: 
  export KUBECONFIG=$PWD/k8s-config
  
Now you are ready to work with your K8S Cluster :-)
  

The code install an 1 control plane and 2 worker nodes, K8S cluster and one pool server for deployments.

Also we install and configure ingress-nginx and metallb.

Prometheus and Grafana will be deployed over ArgoCD with kustomization configuration.

Caution ! 

There are costs as soon as the servers were created.
LoadBalancer and Cloud Volume ( pvc for Grafana ) are also created.

My costs are between 15-20 euros per month ( As of today: November 2021 )

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

## Install Metallb

See: https://metallb.universe.tf/installation/

I use layer 2 configuration

I have configured metallb as single-ip address pool.

File is metallb-l2.yaml
## Install ingress-nginx - with annotation for Hetzner LoadBalancer

### Method 1 for Hetzner Load Balancer

wget https://github.com/kubermatic/kubermatic/releases/download/v2.15.5/kubermatic-ce-v2.15.5-linux-amd64.tar.gz

tar xzf kubermatic-ce-v2.15.5-linux-amd64.tar.gz charts

helm --namespace ingress-nginx upgrade --create-namespace --install nginx-ingress-controller  ./charts/nginx-ingress-controller

kubectl --namespace ingress-nginx annotate --overwrite  service nginx-ingress-controller  "load-balancer.hetzner.cloud/location=nbg1" 
### Method 2 for ingress-nginx as Load Balancer

File is ingress-as-loadbalancer.yaml

In this case the ip of then worker node is the endpoint.
## Prometheus & Grafana

Both will be deployed over ArgoCD.
![alt text](https://github.com/tron4x/kubeone-hetzner/blob/main/jpg/Screenshot%202021-12-10%2023:57:23.png?raw=true)

All yaml files are in direcrory "monitoring"

If you want to change the service type for ArgoCD, from Load balancer to NodePort then execute this:
```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
```

  
Now you are ready to work with your K8S Cluster :+1:
  
## Encrypt your Secret into a SealedSecret
  
   https://github.com/bitnami-labs/sealed-secrets#installation
  
   https://artifacthub.io/packages/helm/bitnami-labs/sealed-secrets
  
  Install with helm3:
  
  helm install --namespace kube-system sealed sealed-secrets/sealed-secrets 

The code install an 1 control plane and 2 worker nodes, K8S cluster and one pool server for deployments.

Also we install and configure ingress-nginx and metallb.

Prometheus, Grafana and Keycloak will be deployed over ArgoCD with kustomization configuration.

Caution ! 

There are costs as soon as the servers were created.
LoadBalancer and Cloud Volume ( pvc for Grafana ) are also created.

My costs are between 15-20 euros per month ( As of today: November 2021 )

## Requirements

[Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

[Helm](https://github.com/helm/helm/releases)

[Kubeone](https://github.com/kubermatic/kubeone)

[Hcloud](https://github.com/hetznercloud/cli)  ( Optional )

## Installation of Infrastructure Cluster

```
 terraform init
 terraform plan
 terraform apply
 terraform output -json > tf.json
```

## Deploy K8S Cluster with KubeOne

- export HCLOUD_TOKEN="<toke here>"  # For Hetzner Cloud
  For other provider take a loo here: 
  https://docs.kubermatic.com/kubeone/v1.3/tutorials/creating_clusters/#step-5--provisioning-the-cluster

- You need private ssh key now:
```
ssh-add ~/.ssh/id_rsa
```
```
kubeone apply -m kubeone.yaml -t tf.json
```  

- export ks config: 
```
export KUBECONFIG=$PWD/k8s-config
```  
## Install Metallb

See: https://metallb.universe.tf/installation/

I use layer 2 configuration

I have configured metallb as single-ip address pool.

File is metallb-l2.yaml
## Install ingress-nginx 

```
kubectl apply -f ingress_deploy.yaml
```

## Prometheus & Grafana

Both will be deployed over ArgoCD
![alt text](https://github.com/tron4x/kubeone-hetzner/blob/main/jpg/Screenshot%202021-12-12%2010:40:43.png?raw=true)

All yaml files are in direcrory "monitoring"

If you want to change the service type for ArgoCD, from Load balancer to NodePort then execute this:
```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
```
![alt text](https://github.com/tron4x/kubeone-hetzner/blob/main/jpg/Screenshot%202021-12-11%2000:02:34.png?raw=true)
![alt text](https://github.com/tron4x/kubeone-hetzner/blob/main/jpg/Screenshot%202021-12-11%2000:06:10.png?raw=true)
  
Now you are ready to work with your K8S Cluster :+1:
## Encrypt your Secret into a SealedSecret
  
   https://github.com/bitnami-labs/sealed-secrets#installation
  
   https://artifacthub.io/packages/helm/bitnami-labs/sealed-secrets
  
  Install with helm3:
  
  helm install --namespace kube-system sealed sealed-secrets/sealed-secrets 

## Keycloak

Deployment over ArgoCD.

![alt text](https://github.com/tron4x/kubeone-hetzner/blob/main/jpg/Screenshot%202021-12-12%2010:43:53.png?raw=true)

## Kubernetes Dashboard

Deployment over Argocd:

https://github.com/tron4x/kubeone-hetzner/tree/main/service/k8s-ddashboard

You have to login with token.

Token can be viewed with:
```
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
```
## pod,svc and pvc outputs

### Pods

![alt text](https://github.com/tron4x/kubeone-hetzner/blob/main/jpg/k8s/Screenshot%202021-12-12%2010:59:56.png?raw=true)

### Services

![alt text](https://github.com/tron4x/kubeone-hetzner/blob/main/jpg/k8s/Screenshot%202021-12-12%2011:01:14.png?raw=true)

### PVC

![alt text](https://github.com/tron4x/kubeone-hetzner/blob/main/jpg/k8s/Screenshot%202021-12-12%2011:01:53.png?raw=true)
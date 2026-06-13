# Bootstrap Guide

## 1. Apply Dev Infrastructure

```bash
cd envs/dev
terraform init -backend=false
terraform apply
```

## 2. Access the Cluster

```bash
aws eks update-kubeconfig \
  --region ap-south-2 \
  --name ssvd-dev-eks
```

## 3. Check Argo CD

```bash
kubectl get pods -n argocd
kubectl get applications -n argocd
```

## 4. Port Forward Argo CD

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## 5. Get Initial Admin Password

```bash
kubectl get secret argocd-initial-admin-secret \
  -n argocd \
  -o jsonpath="{.data.password}" | base64 -d
```

Open `https://localhost:8080` and log in with user `admin`.

# Kubectl-basics

commands fpr k8s:

https://gitlab.com/nanuchi/youtube-tutorial-series/-/blob/master/basic-kubectl-commands/cli-commands.md

*Important!* Please install kubectl autocomplete in bash, so it will be easier to use. Also install `k9s` for getting info easier

for M1 start for minikube:

```
minikube start --driver=docker
```

For more info please see:

- https://github.com/kubernetes/minikube/issues/9224
- https://stackoverflow.com/questions/71207905/minkube-start-gives-error-exiting-due-to-rsrc-insufficient-cores-is-it-poss/71579753#71579753

to check, that minukube has been started:

```
kubectl get nodes
NAME       STATUS   ROLES           AGE     VERSION
minikube   Ready    control-plane   2m52s   v1.26.1
```

another way to check minikube :

```
minikube status
```

Kubectl get statuses commands:

```
kubectl get nodes
NAME       STATUS   ROLES           AGE     VERSION
minikube   Ready    control-plane   6m47s   v1.26.1
kubectl get pod
No resources found in default namespace.
kubectl get services
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
...
```

Create deployment:

```
kubectl create deployment nginx-depl --image=nginx
deployment.apps/nginx-depl created

❯ kubectl get deployments.apps
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
nginx-depl   1/1     1            1           14s

❯ kubectl get replicasets.apps
NAME                   DESIRED   CURRENT   READY   AGE
nginx-depl-<id>   1         1         1       2m46s
```

To change deployment:

```
kubectl edit deployments.apps nginx-depl
deployment.apps/nginx-depl edited
```
and here you can change default configuration, e.g. change version of docker image. Btw kubectl will update current version of deployment instead of recreation

Kubectl logs:

```
kubectl logs mongo-depl-<id>
....
kubectl describe pod mongo-depl-<id>
Name:             mongo-depl-<...>
```

Go inside of container:
```
kubectl exec -it  <deployment-name> -- bin/bash
root@<deployment-name>:/# whoami
root
```

Remove deployment:

```
❯ kubectl delete deployments.apps mongo-depl
deployment.apps "mongo-depl" deleted
❯ kubectl get deployments.apps
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
nginx-depl   1/1     1            1           21m
```

Kubectl - deploy with yaml

```
kubectl apply -f <name-of-file.yaml>

kubectl apply -f nginx-deployment.yaml
deployment.apps/nginx-deployment created
kubectl get pod
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-<id>   1/1     Running   0          9s
```

it detects if deployment already exists and update configuration instead of recreation

describe service:

```
kubectl describe service nginx-service
```

get more info, including ip:

```
kubectl get pod -o wide
```

get result in yaml format:
```
kubectl get deployments.apps nginx-deployment -o yaml
```
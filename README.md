# Kubectl-basics

commands fpr k8s:

https://gitlab.com/nanuchi/youtube-tutorial-series/-/blob/master/basic-kubectl-commands/cli-commands.md

*Important!* Please install kubectl autocomplete in bash, so it will be easier to use. Also install `k9s` for getting info easier

*Yaml schema validation for VS Code* Install YAML extension and paste in `settings.json`:

```
 "yaml.schemas": {
    "kubernetes": "*.yaml"
  },
```

See for detailed info: https://brain2life.hashnode.dev/how-to-enable-syntax-auto-completion-for-kubernetes-manifest-files-in-red-hats-yaml-plugin-for-vscode


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

Create deployment from file:

```
kubectl create -f <yaml-file-name>
```



To see live log from pod:

```
kubectl get pod --watch
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

Convert strings to base64:

```
echo -n '<word>' | base64
```

Secret must be applied before deployment, otherwise deployment won't work:

```
kubectl apply -f <secret>.yaml
```

Get secrets:

```
kubectl get secrets
```

Get services:

```
kubectl get services
```

How to check, that service is applied to pod:

```
kubectl describe service <service-name>
```

And `Endpoints` must match the ip of pod

Kubectl - print all components, relevant to deployment:

```
kubectl get all | grep mongodb
```

To open public service in minukube (but in real kubernetes external IP is assigned automatically):

```
minikube service <service-name>
```

Namespaces:

- they are needed to group resources (databases in one namespace, monitoring in another namespace, etc.)
- if 2 teams use the same app, but different configuration
- you have components you want to reuse in couple of envs..
- with creation namespaces, it's possible to give team access to project A in namespace and team 2 to project B to another namespace, limit resource (CPU for example)
- each namespace must define own ConfigMap, secret
- service can be shared between namespaces
- volumes and nodes aren't located in namespaces, they can't be isolated

Kubectl get namespaces:

```
kubectl get namespaces
```

Kubectl create namespace:

```
kubectl create namespace <namespace-name>
```

But you can create namespace, using config file

to show all resources which can't be created in namespace:

```
kubectl api-resources --namespaced=false
```

```
kubectl get all -n <namespace-name>
```


```
❯ kubectl get configmap -n <namespace-name>
NAME               DATA   AGE
kube-root-ca.crt   1      3h12m
mysql-configmap    1      23m
❯ kubectl get secret -n <namespace-name>
NAME           TYPE     DATA   AGE
mysql-secret   Opaque   1      105s
```

How to remove everything in kubectl:

```
kubectl delete all --all -n <namespace-name>
```

To remove kubectl secret:

```
kubectl delete -n <namespace-name> secret <secret-name>
```

To remove configmap:

```
kubectl delete -n <namespace-name> configmaps <configmap-name>
```

For more short work with namespaces:

```
brew install kubectx
```

and then type:

```
kubens
```

it shows all namespaces.

In order to switch to the right one:

```
kubens <namespace-name>
```
# Kubectl-basics

## Configuration

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

minikube - start with specific parameters (need to rm and start it again):

```
❯ minikube delete
❯ minikube start --memory 4096
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

## Deployments

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

or:

```
kubectl get svc
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

## Namespaces:

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

## Ingress (testing example with work of minikube)

minikube ingress controller (for learning and testing purposes)

to enable ingress in minikube (automatically starts the K8s Nginx implementation of ingress)

```
ingress addons enable ingress
```

and ingress controller will be configured automatically

To check it (you see like nginx-ingress-controller):

```
kubectl get pod -n kube-system
```

## Helm

You can use helm hub to search specific helm structure

https://artifacthub.io/packages/search


basic command to start:

```
helm create <project-name>
```

```
helm create fleetman-helm-chart
```

it creates helm project with name specific name

to check structure:

```
tree <project-name>
```

helm - install project: search project and open detailed info. Usually it can be installed like:

```
helm repo add <label> <repo-name>
helm install <label-name> <label/>release-name>

# example - might be changed in the future
helm repo add my-bitnami https://charts.bitnami.com/bitnami
helm install mysql bitnami/mysql
```

where `label-name` is something which might be recognizable, because it will be used for whole kubernetes deployment.
`release-name` is taken from package description

of you can install helm chart if you've already had chart files locally:

```
helm install <label-name> <path-to-chart-folder>
```

```
helm install monitoring ./kube-prometheus-stack
```

Then you can check deployment by

```
kubectl get pods -w --namespace default
```

or you can use shorcut `po`:

```
kubectl get po -w --namespace default
```

and output will be like:

```
❯ kubectl get pods -w --namespace default
NAME                            READY   STATUS    RESTARTS      AGE
mysql-0                         1/1     Running   0             2m20s
```

to show all helm charts (it shows version, status, etc.)

```
helm list
```
to uninstall helm:

```
helm uninstall mysql
```

*Attention!*  Helm - stable chart repos - deprecated, use ArtifactHUB instead,
so far there's no stable repo yet

Example of work of `kube-prometheus-stack` helm (Prometheus + Grafana)

Add helm repo:

https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm repo list
```

And then install it:

```
helm install <RELEASE_NAME> prometheus-community/kube-prometheus-stack
```

<RELEASE_NAME> is your name, so you can call it as you wish:

```
helm install monitoring prometheus-community/kube-prometheus-stack
```

or if you have char locally

```
helm install <RELEASE_NAME> <path-to-helm-char-folder>
```

```
helm install monitoring ./kube-prometheus-stack
```


and then check, that installation was successful:

```
kubectl --namespace default get pods -l "release=monitoring"
```

to open Grafana monitoring svc locally for testing:

```
kubectl edit svc monitoring-grafana
```
and then change in yaml file:

```
 ports:
  - name: http-web
    port: 80
    protocol: TCP
    targetPort: 3000
    nodePort:30001 # add this param
  selector:
    app.kubernetes.io/instance: monitoring
    app.kubernetes.io/name: grafana
  sessionAffinity: None
  type: NodePort # change type here
```

And after that on minikube-docker you can see it by:

```
minikube service monitoring-grafana
```

this will be because you're on the docker driver, which runs minikube as a docker container. This is good because it is more stable and efficient that running minikube under some kind of VM - but the problem is, you've got 2 network hops to get into the container - one to get past the vm that docker is running under, and then another hop to get to the node port. It's the minikube service command that gets you into that VM.

helm - show possible chart values

```
helm show values <label-name> <label/>release-name>
```

```
helm show values prometheus-community/kube-prometheus-stack > values.yaml
```

helm uses `values.yaml` for configuration cluster

to update specific value - find it in values.yaml and then update:

```
helm upgrade <label-name> <label/>release-name> --set <key>=<value>
```

In example we use `grafana` prefix here, because `adminPassword` is child of `grafana` - be careful!

```
helm upgrade monitoring prometheus-community/kube-prometheus-stack --set grafana.adminPassword=admin
```

or this one (values can be found in chart documentation):

```
helm upgrade monitoring prometheus-community/kube-prometheus-stack \
    --set grafana.adminPassword=admin  \
    --set grafana.service.type=NodePort \
    --set grafana.service.nodePort=30001
```

Or you can directly add values in grafana.service section like this in `values.yaml` (located in `helm_examples`):

```
  ## Passed to grafana subchart and used by servicemonitor below
  ##
  service:
    portName: http-web
    type: NodePort
    nodePort: 30008
```

And after that make upgrade:

```
helm upgrade monitoring prometheus-community/kube-prometheus-stack --values=./values.yaml
```

You can even play around and upload only values you need, so shorten `values.yaml` to values you need and upload only them (but it's used only for small testing only):

```
grafana:
  ## Passed to grafana subchart and used by servicemonitor below
  ##
  service:
    portName: http-web
    type: NodePort
    nodePort: 30008
```

Better practice is to create like separated file `myvalues.yaml` and put there values you would like (see `helm_examples/my-cluster-config/kube-prometheus-stack/myvalues.yaml`)

Command to upgrade local chart

```
helm upgrade <label-name> --values=<values-file> <path-to-local-chart-folder>
```

```
helm upgrade monitoring --values=myvalues.yaml .
```

How to download helm chart locally:

```
helm pull [chart URL | repo/chartname]
```

- `repo/chartname` is the same as for helm install
- `chart URL` is url on github, where helm chart files are located


```
helm pull prometheus-community/kube-prometheus-stack --untar
```
or

```
helm pull bitnami/mysql --untar
```

`--untar` allows to unpack zip automatically

Helm - generate yaml, which described cluster, but doesn't apply it!

```
helm template [NAME] [CHART] [flags]
```

```
helm template monitoring ./kube-prometheus-stack --values=./kube-prometheus-stack/myvalues.yaml
```

```
helm template monitoring ./kube-prometheus-stack --values=./kube-prometheus-stack/myvalues.yaml > monitoring-stack.yaml
```


or for gebugging current helm chart:

```
helm template .
```

to rewrite specific value (from values.yaml as in example):

```
helm template . --set webapp.numberOfWebbAppReplicas=12
```

and then simply apply cluster without any helm command:

```
kubectl apply -f monitoring-stack.yaml
```
# a9s homework: Deploy a go app to kubernetes

The goal of this homework is to containerize a go application
and then to deploy it to a Kubernetes cluster.

## 1. Containerize the go app [completed]

For the ease of accessibility , I stored all the environment variables in [`var.env`](./docker/var.env) file.
The [`Dockerfile`](./docker/Dockerfile) uses two-stage build, but on top of the build `postgres:latest` image is also used to construct a docker container(to connect to) in the [`docker-compose.yml`](./docker/docker-compose.yml) file. Since `apline:latest` didn't already have a running postgres server to connect to.

### 1.1. Clone the Repository

You may clone the repository with the following command
```bash
git clone git@github.com:riturajsingh2015/homework.git ~/workspace/homework
```

### 1.2 Change directory 

Change to the directory to the location contain the `docker-compose.yml` file
```bash
cd ~/workspace/homework/kubernetes/docker
```

### 1.3 Execute Docker Compose  
Once we are in the `docker` folder you can execute the docker compose up command which will :
- Create a `database` container running postgres
- Create a `rest_api` container running which will run our go-app
- Build the go-app on `golang:latest` as base image
- Shift it using the built app to `apline:latest`
- And run the go-app through `rest_api` container

```bash
docker compose up
```
One may check the proper working of all the **routes** using `Postman`

## 2. Deploy the go app to kubernetes [completed]

**Note** 
- I used wsl2 ubuntu distro to work on my local windows machine
- Minikube and kubectl were installed on this ubuntu distro

Following are the steps involved in deploy our go app on a kubernetes cluster: 

### 2.1. Clone the Repository

You may clone the repository with the following command
```bash
git clone git@github.com:riturajsingh2015/homework.git ~/workspace/homework
```
### 2.2 Change directory 

Change to the directory to the resources folder
```bash
cd ~/workspace/homework/kubernetes/docker/resources
```

### 2.3 Start a Minikube Cluster

Start a minikube cluster
```bash
minikube start
```
### 2.4 Postgres Pod

Create a pod for Postgres while being in the resource folder
- Pod will use a confgimap containing the environment variables
- It will also create a persistant storage
- And the pod will be accessbile through `postgres` service

```bash
postgres/create.sh
```

### 2.4 go-app Pod

Create a pod for go-app while being in the resource folder
- Pod will pull image `riturajsingh2015/go_app_api:v1` to spin a container
- The image is the same image build from [`Dockerfile`](./docker/Dockerfile) 
- And the pod will be accessbile through an external service `go-app-service` service
- `go-app-service` is accessible through nodeport 30000 and on service port 8080

```bash
go_app/create.sh
```

### 2.5 Check your Pod and services
```
kubectl get services
kubectl get pods
```
### 2.6 Forward the port of go-app service (If you have Minikube setup on your WSL2 distro)
- Our go-app-service was an external service working on port 8080 
- It can forwarded to port 5000 on localhost or our local machine running windows using the following command
```bash
kubectl port-forward svc/go-app-service 5000:8080 --address='0.0.0.0'
```
- To access the service use http://localhost:5000
- Or use Postman to send GET | POST requests to the service

### 2.7 Create a public IP for go-app service (If you have Minikube setup on your Local Machine)
- Our go-app-service was an external service working on nodeport 30000 
- Service can accessed through this nodeport 30000 on local machine using the following command
```bash
minikube service go-app-service --url
```
- This will give you a link to access your go-app-service http://XXXXXXX:30000
- Or use Postman to send GET | POST requests to the service


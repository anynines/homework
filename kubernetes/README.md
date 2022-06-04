# a9s homework: Deploy a go app to kubernetes

The goal of this homework is to containerize a go application
and then to deploy it to a Kubernetes cluster.

## 1. Containerize the go app [completed]

For the ease of accessibility , I stored all the environment variables in [`var.env`](./docker/var.env) file
The Dockerfilie uses two stage build but on top of the build `postgres:latest` image is also used in the to construct a docker container

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

## 2. Deploy the go app to kubernetes

Remaining
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

## 2. Deploy the go app to kubernetes

Remaining
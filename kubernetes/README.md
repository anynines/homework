# a9s homework: Deploy a go app to kubernetes

The goal of this homework is to containerize a go application
and then to deploy it to a Kubernetes cluster.

## 1. Containerize the go app

In the `docker/` folder you will find a empty Dockerfile and a folder `docker/go-app/` containing the source code of the app.

The app is a simple CRUD todo app which uses PostgreSQL as a
database to store the todos. It's possible to build the app without a connected db. The app should start up, but accessing any route will lead to an error.
The PostgreSQL connection details should be stored in environment variables of the container -> investigate the code for more details (just search for `POSTGRESQL_`).

Your **frist task** is to containerize the go app.
Write the necessary code in the empty Dockerfile you will find in the `docker/` folder.

**Bonus**:<br/>
The container image that runs your binary should be small, but we don't want to lose convenience during the building phase of the app in the container.
Therefore you should use two stages in your dockerfile.<br />
The first stage will be the build-stage which uses the `golang:latest` image as a base.<br/>
And the Second and final stage should be based on the `apline:latest` image.

## 2. Deploy the go app to kubernetes

We now want to deploy the app with a connected PostgreSQL database in Kubernetes. You can use minikube for that part of the exercise (or any other kubernetes cluster tool you prefer).

Your **second task** is to write all the necessary yaml-resource definitions you need to deploy the app with a PostgreSQL database to Kubernetes. Please add these definitions to the `resources` folder of the repo.<br/>
Don't use any helm charts for this task. The PostgreSQL database should be just a single instance -> no HA-setup is needed.

**Bonus**:<br/>
Make the app accessible from the outside through Ingress into your kubernetes cluster. You can use a helm chart for this task.
The app should be accessible via the route `<host>/app`.

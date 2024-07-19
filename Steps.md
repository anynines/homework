# installed ruby, docker
# prepared docker to run a postgres container
docker network create some-network
docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' some-postgres

# test the connection
psql -h 172.18.0.2 -U postgres


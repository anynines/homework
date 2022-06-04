FROM golang:latest AS builder

RUN mkdir /go-app
ADD ./go-app /go-app
WORKDIR /go-app

RUN CGO_ENABLED=0 GOOS=linux go build -o go-app main.go

FROM alpine:latest AS production
COPY --from=builder /go-app .

# install postgresql
# RUN apk add --no-cache postgresql

# RUN mkdir /run/postgresql
# RUN chown postgres:postgres /run/postgresql/

# RUN su postgres -
# USER postgres
# RUN mkdir /var/lib/postgresql/data
# RUN chmod 0700 /var/lib/postgresql/data
# RUN initdb -D /var/lib/postgresql/data
# RUN pg_ctl start -D /var/lib/postgresql/data
# RUN psql

# Environment variables
# ENV POSTGRES_HOST 0.0.0.0
# ENV POSTGRES_USER postgres
# ENV POSTGRES_PORT 5432
# ENV POSTGRES_PASSWORD postgres
# ENV POSTGRES_DB postgres



CMD ["./go-app"]
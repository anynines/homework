FROM golang:latest AS builder

RUN mkdir /go-app
ADD ./go-app /go-app
WORKDIR /go-app

RUN CGO_ENABLED=0 GOOS=linux go build -o go-app main.go

FROM alpine:latest AS production
COPY --from=builder /go-app .

CMD ["./go-app"]
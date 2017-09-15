FROM golang:1.8.3-alpine3.6

WORKDIR /go/src/app
COPY . .

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

RUN go-wrapper download
RUN go-wrapper install
RUN go build -o aws-es-proxy

FROM alpine:3.6

COPY --from=0 /go/src/app/aws-es-proxy /
RUN apk update && apk upgrade && \
    apk add --no-cache ca-certificates

ENV PORT_NUM 9200
CMD ["./aws-es-proxy", "-h"]
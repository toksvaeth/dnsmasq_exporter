# build stage
FROM golang:1.21-alpine AS build-env
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
ENV CGO_ENABLED=0
RUN go build -ldflags="-w -s" -o dnsmasq_exporter

# final stage
FROM scratch
WORKDIR /app
COPY --from=build-env /src/dnsmasq_exporter /app/
USER 65534
EXPOSE 9153
ENTRYPOINT ["/app/dnsmasq_exporter"]

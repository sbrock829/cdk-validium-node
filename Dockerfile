# CONTAINER FOR BUILDING BINARY
FROM golang:1.22 AS build

# INSTALL DEPENDENCIES
RUN go install github.com/gobuffalo/packr/v2/packr2@v2.8.3
COPY go.mod go.sum /src/
#RUN cd /src && go mod download
RUN cd /src

# BUILD BINARY
COPY . /src
RUN cd /src/db && packr2
RUN cd /src && make build

# CONTAINER FOR RUNNING BINARY
FROM alpine:3.18
COPY --from=build /src/dist/zkevm-node /app/zkevm-node
RUN apk update && apk add postgresql15-client
EXPOSE 8123
CMD ["/bin/sh", "-c", "/app/zkevm-node run"]

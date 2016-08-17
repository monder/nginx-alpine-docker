FROM nginx:1.11.1-alpine

RUN apk add --no-cache s6 && \
    \
    apk add --no-cache go git gcc musl-dev && \
    git clone https://github.com/kelseyhightower/confd /src/confd && \
    cd /src/confd && \
    git checkout -q --detach "20b3d37" && \
    cd /src/confd/src/github.com/kelseyhightower/confd && \
    GOPATH=/src/confd/vendor:/src/confd go build -a -installsuffix cgo -ldflags '-extld ld -extldflags -static' -x . && \
    mv ./confd /bin/ && \
    chmod +x /bin/confd && \
    apk del go git gcc musl-dev && \
    rm -rf /src

ADD root /

CMD ["s6-svscan", "/s6"]

FROM caleblloyd/phusion-baseimage-docker-15.04
MAINTAINER Frank Denis
ENV SERIAL 4

ENV GOROOT /opt/go
ENV PATH $PATH:/opt/go/bin

ENV DEBIAN_FRONTEND noninteractive
ENV BUILD_DEPS \
    autoconf \
    bzr \
    cmake \
    debhelper \
    fakeroot \
    file \
    gcc \
    git \
    golang-goprotobuf-dev \
    libc-dev \
    make \
    mercurial \
    patch \
    pkg-config \
    protobuf-compiler \
    python-sphinx \
    ruby-dev \
    wget

RUN set -x && \
    apt-get update

RUN set -x && \
    apt-get install -y \
        $BUILD_DEPS \
        bsdmainutils \
        ca-certificates \
        jed \
        libgeoip-dev \
        lua5.2-dev \
        lua-cjson-dev \
        --no-install-recommends

ENV GOLANG_VERSION 1.5beta3
ENV GOLANG_SHA256 50823fb97b2c7daa340d1dbf8ea94892c4063d41c3e58d1c3b1ec42636f371c9
ENV GOLANG_DOWNLOAD_URL https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz

RUN set -x && \
    mkdir -p /tmp/src && \
    cd /tmp/src && \
    curl -sSL $GOLANG_DOWNLOAD_URL -o golang.tar.gz && \
    echo "${GOLANG_SHA256} *golang.tar.gz" | sha256sum -c - && \
    mkdir -p /opt && \
    tar xz -C /opt -f golang.tar.gz && \
    rm -f golang.tar.gz && \
    rm -fr /opt/go/{doc, src, test, pkg, api} && \
    go version && \
    rm -fr /tmp/*

RUN set -x && \
    mkdir -p /tmp && \
    cd /tmp && \
    git clone https://github.com/mozilla-services/heka

COPY heka.patch /tmp/heka/

RUN set -x && \
    cd /tmp/heka && \
    git checkout 28690a9e3fed52e6b99ef7750ad685219ea39c00 && \
    patch -p1 < heka.patch && \
    ./build.sh && \
    mkdir -p /opt && \
    mv /tmp/heka /opt/

RUN set -x && \
    mkdir -p /opt/heka/build/heka/share/heka/lua_modules && \
    mv /opt/heka/build/heka/lib/luasandbox/modules/* /opt/heka/build/heka/share/heka/lua_modules/ && \
    mkdir -p /opt/heka/build/heka/share/heka/lua_decoders && \
    mv /opt/heka/sandbox/lua/decoders/* /opt/heka/build/heka/share/heka/lua_decoders/ && \
    mv /opt/heka/dasher /opt/heka/build/heka/share/heka/dasher && \
    rm -fr /tmp/*

RUN set -x && \
    apt-get purge -y --auto-remove $BUILD_DEPS && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY hekad.toml.in /etc/
COPY entrypoint.sh /
COPY gelf_encoder.lua /opt/heka/local/lua_encoders/gelf.lua
COPY heka.pem /etc/ssl/private/

ENV KAFKA_BROKERS='["127.0.0.1:9292", "127.0.0.2:9292"]'
ENV KAFKA_TOPIC=topic
ENV EXTRA_PROPERTIES='{"X-TEST-TOKEN": 69, "X-TEST-TOKEN-2": 42}'
ENV USE_TLS=false

EXPOSE 6514 4352

ENTRYPOINT ["/entrypoint.sh"]

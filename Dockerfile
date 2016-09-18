FROM alpine:3.4

MAINTAINER Johnie Hjelm <johniehjelm@me.com>

# Set default node, npm versions and timezone
ARG BUILD_NODE_VERSION=6.6.0 
ARG BUILD_NPM_VERSION=3
ARG BUILD_TIMEZONE=Europe/Stockholm

# Set environment variables
ENV NODE_VERSION=${BUILD_NODE_VERSION}
ENV NPM_VERSION=${BUILD_NPM_VERSION}
ENV TIMEZONE=${BUILD_TIMEZONE}

# Let's roll
RUN info() { printf '\n--\n\t%s\n--\n\n' "$*"; } && \ 
  info "==> Installing dependencies..." && \ 
  apk update && \
  apk upgrade && \
  apk add --update tzdata && \
  cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
  echo "${TIMEZONE}" > /etc/timezone && \
  apk add --virtual build-deps \
    curl make gcc g++ python paxctl \
    musl-dev openssl-dev zlib-dev \
    linux-headers binutils-gold && \
  mkdir -p /root/nodejs && \
  cd /root/nodejs && \
  info "==> Downloading..." && \
  curl -sSL -o node-${NODE_VERSION}.tar.gz http://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.tar.gz && \
  curl -o SHASUMS256.txt.asc -sSL https://nodejs.org/dist/v${NODE_VERSION}/SHASUMS256.txt.asc && \
  grep node-${NODE_VERSION}.tar.gz SHASUMS256.txt.asc | sha256sum -c - && \
  info "==> Extracting..." && \
  tar -zxf node-${NODE_VERSION}.tar.gz && \  
  cd node-v${NODE_VERSION} && \
  info "==> Configuring..." && \
  readonly NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || echo 1) && \
  echo "using upto $NPROC threads" && \
  ./configure \
   --prefix=/usr \
   --shared-openssl \
   --shared-zlib && \
  info "==> Building..." && \
  make -j$NPROC -C out mksnapshot && \
  paxctl -c -m out/Release/mksnapshot && \
  make -j$NPROC && \
  info "==> Installing..." && \
  make install && \
  info "==> Finishing..." && \
  apk del build-deps && \
  apk add \
    openssl libgcc libstdc++ && \
  rm -rf /var/cache/apk/* && \
  info "==> Updating NPM..." && \
  npm i -g npm@$NPM_VERSION && \
  info "==> Cleaning up..." && \
  npm cache clean && \
  rm -rf ~/.node-gyp /tmp/* && \
  rm -rf /root/nodejs && \
  echo "You\'re all finished!"

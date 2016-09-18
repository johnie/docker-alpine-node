# docker-alpine-node [![Build Status](https://travis-ci.org/johnie/docker-alpine-node.svg?branch=master)](https://travis-ci.org/johnie/docker-alpine-node)

> A [Docker](https://www.docker.com/) image for [Node.JS](https://nodejs.org/) based on [_/alpine:3.4](https://hub.docker.com/_/alpine/).

## Prerequisites

Install [Docker](https://docker.com/).

## Obtaining the Docker image

### Downloading the Docker image from Docker Hub

This is the simplest and the fastest solution to get a pre-built image:

```bash
docker pull johnie/docker-alpine-node
```

### Building the Docker image locally

Please note that this option will take a longer time to be executed.

```bash
git clone https://github.com/johnie/docker-alpine-node.git
cd docker-alpine-node
docker build -t johnie/docker-alpine-node .
```

This image use Europe/Stockholm timezone by default. You can change the timezone by changing the `TIMEZONE` environment on Dockerfile or specify `--build-arg BUILD_TIMEZONE` and then build.

## Running the Docker image as a container

```bash
$ docker run --rm -it johnie/docker-alpine-node node --version && npm --version
v6.6.0
3.10.3
```

## Example Dockerfile for your own Node.js project

If you don't have any native dependencies, ie only depend on pure-JS npm modules, then my suggestion is to run npm install locally before running docker build (and make sure node_modules isn't in your .dockerignore) – then you don't need an npm install step in your Dockerfile and you don't need npm installed in your Docker image – so you can use one of the smaller base* images.

```docker
FROM johnie/docker-alpine-node

WORKDIR /src
ADD . .

# If you have native dependencies, you'll need extra tools
# RUN apk add --no-cache make gcc g++ python

RUN npm install

EXPOSE 3000
CMD ["node", "index.js"]
```

## Node and NPM

The current working version of Node is **v6.6.0** and NPM is **3.10.3**, which is set by default in the Docker image.

You can easily choose any [former version](https://nodejs.org/en/download/releases/) when building the Docker image locally:

```bash
docker build --build-arg BUILD_NODE_VERSION=4 BUILD_NPM_VERSION=2 -t johnie/docker-alpine-node .
```

## License

Released under the [MIT license](https://opensource.org/licenses/MIT) by Johnie Hjelm.

# Alpine-node

Docker images for node with pre configured USER hacker in GROUP redelivre.

This user has sudo permissions without password required.

## Install

```
$ git clone git://gitlab.com/install/alpine-node.git
$ cd alpine-node
$ docker-compose up -d
```

## Using in other `docker-compose.yml` file:

```yaml
version: '2'
services:
    mynode:
        extends: <path-to-my-clone>
        service: node_8
```

## Using in another `Dockerfile`

Call directive `FROM redelivre/node:8`, switch to `USER hacker` and `WORKDIR /home/hacker` 

```
FROM redelivre/alpine-node:8
USER hacker
WORKDIR /home/hacker
...
``` 

Now you can sudo global dependencies, install packages and run:

```
...
RUN sudo -g <dependencies>
RUN yarn
CMM npm start
...
```
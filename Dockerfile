FROM redelivre/alpine:latest
ENV NODE_VERSION v10.11.0
ENV NPM_VERSION 6
ENV YARN_VERSION latest
ARG CONFIG_FLAGS="--fully-static"
ARG DEL_PKGS="libstdc++"
ARG RM_DIRS="/usr/include"
ARG DEPENDENCIES="binutils-gold gnupg libstdc++ xz python"
ARG POOLS="ipv4.pool.sks-keyservers.net keyserver.pgp.com ha.pool.sks-keyservers.net"
ARG KEYS="94AE36675C464D64BAFA68DD7434390BDBE9B9C5 B9AE9905FFD7803F25714661B63B535A4C206CA9 77984A986EBC2AA786BC0F66B01FBB92821C587A 71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 FD3A5288F042B6850C66B31F09FE44734EB7990E 8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 DD8F2338BAE7501E3DD5AC78C273792F7D83545D 6A010C5166006599AA17F08146C2130DFD2497F5"

USER $username
RUN apk add --no-cache --virtual built-essentials-node $DEPENDENCIES

RUN for server in $POOLS; do gpg --keyserver $server --recv-keys $KEYS && break ; done

WORKDIR /tmp
RUN curl -sfSLO $(echo "https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION.tar.xz")
RUN curl -sfSL $(echo "https://nodejs.org/dist/$NODE_VERSION/SHASUMS256.txt.asc") | gpg --batch --decrypt | grep " node-$NODE_VERSION.tar.xz\$" | sha256sum -c | grep ': OK$'
RUN tar -xf $(echo "/tmp/node-$NODE_VERSION.tar.xz")

WORKDIR /tmp
RUN curl -sfSL -O https://yarnpkg.com/${YARN_VERSION}.tar.gz -O https://yarnpkg.com/${YARN_VERSION}.tar.gz.asc \
    && gpg --batch --verify ${YARN_VERSION}.tar.gz.asc ${YARN_VERSION}.tar.gz \
    && mkdir /usr/local/share/yarn \
    && tar -xf ${YARN_VERSION}.tar.gz -C /usr/local/share/yarn --strip 1 \
    && ln -s /usr/local/share/yarn/bin/yarn /usr/local/bin/ \
    && ln -s /usr/local/share/yarn/bin/yarnpkg /usr/local/bin/ \
    && rm ${YARN_VERSION}.tar.gz*

WORKDIR /tmp/node-$NODE_VERSION
RUN ./configure --prefix=/usr ${CONFIG_FLAGS} \
  && make clean \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install

WORKDIR /home/$username
RUN npm install -g npm@${NPM_VERSION} \
    && find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf
RUN apk --virtual del built-essentials-node
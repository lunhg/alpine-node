FROM redelivre/alpine:latest
ARG NODE_VERSION
ARG NPM_VERSION
ARG YARN_VERSION
USER $username
WORKDIR /tmp
RUN curl -sfSLO $(echo "https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION.tar.xz") \
    && curl -sfSL $(echo "https://nodejs.org/dist/$NODE_VERSION/SHASUMS256.txt.asc") | gpg --batch --decrypt | grep " node-$NODE_VERSION.tar.xz\$" | sha256sum -c | grep ': OK$' \
    && tar -xf $(echo "/tmp/node-$NODE_VERSION.tar.xz") \
    && curl -sfSL -O https://yarnpkg.com/${YARN_VERSION}.tar.gz -O https://yarnpkg.com/${YARN_VERSION}.tar.gz.asc \
    && gpg --batch --verify ${YARN_VERSION}.tar.gz.asc ${YARN_VERSION}.tar.gz \
    && mkdir /usr/local/share/yarn \
    && tar -xf ${YARN_VERSION}.tar.gz -C /usr/local/share/yarn --strip 1 \
    && ln -s /usr/local/share/yarn/bin/yarn /usr/local/bin/ \
    && ln -s /usr/local/share/yarn/bin/yarnpkg /usr/local/bin/ \
    && rm ${YARN_VERSION}.tar.gz*

WORKDIR /tmp/node-$NODE_VERSION
RUN ./configure --prefix=/usr --debug --without-snapshot --fully-static --dest-cpu `uname -p` --dest-os liRUN make clean \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install

WORKDIR /home/$username
RUN npm install -g npm@${NPM_VERSION} \
    && find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf \
    && apk --virtual del build-essentials
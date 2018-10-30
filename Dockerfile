ARG NODE_VERSION
FROM mhart/alpine-node:${NODE_VERSION}
ARG username
RUN adduser -G wheel -D -h /home/$username $username \
    && echo "%wheel ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && chown -R $username: /home/$username
COPY . /home/$username
ENTRYPOINT npm run --prefix=/home/$username

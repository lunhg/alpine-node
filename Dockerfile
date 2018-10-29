FROM resin/aarch64-alpine-node:latest
ARG username
RUN adduser -G wheel -D -h /home/$username $username \
    && echo "%wheel ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && chown -R $username: /home/$username
COPY . /home/$username
USER $username
WORKDIR /home/$username
ENTRYPOINT npm run --prefix=/home/$USER


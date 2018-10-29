USER={$USER:=$(whoami)}
NODE_VERSION={$NODE_VERSION:='latest'}
PREFIX={$PREFIX:=/home/$USER}
for i "username=$USER" \
        "NODE_VERSION=$NODE_VERSION" ; do \
    echo $i >> $PREFIX/.env
done

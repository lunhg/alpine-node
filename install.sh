for i "username=$(whoami)" \
        "NODE_VERSION=latest" ; do \
    echo $i >> .env
done

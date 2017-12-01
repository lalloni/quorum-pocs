#!/bin/zsh
docker build --rm --build-arg http_proxy="$http_proxy" --build-arg no_proxy="$no_proxy" --tag quorum .

#!/bin/bash

# hacky deploy script

stack build
rm -r _site/*
stack exec wycd clean
stack exec wycd build
rsync --delete -arv --exclude ".*/" _site/* ../wycd.net-deploy
(cd ../wycd.net-deploy && git add . && \
    git commit -m'deploy' && git push origin HEAD)

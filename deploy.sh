#!/bin/bash

# hacky deploy script

stack build
rm -r _site/*
stack exec wycd build
rm -r ../wycd.net-deploy/*
cp -r _site/* ../wycd.net-deploy
(cd ../wycd.net-deploy && git add . && \
    git commit -m'deploy' && git push origin HEAD)

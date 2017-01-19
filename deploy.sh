#!/bin/bash

# hacky deploy script

stack build
stack exec wycd build
cp -r _site/* ../wycd.net-deploy
(cd ../wycd.net-deploy && git add . && \
    git commit -m'deploy' && git push origin HEAD)

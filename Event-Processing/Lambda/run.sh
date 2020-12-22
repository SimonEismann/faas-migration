#!/bin/sh

export GIT_MERGE_AUTOEDIT=no
git pull
git checkout $EXP_BRANCH
git pull
git merge master --no-edit
git add *
git commit -m "automerge"

# Setup IAM role
serverless deploy | tee output.txt
sleep 3000

# Shutdown
serverless remove
git stash --include-untracked

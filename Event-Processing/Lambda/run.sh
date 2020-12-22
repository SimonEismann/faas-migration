#!/bin/sh

export GIT_MERGE_AUTOEDIT=no
git pull
git checkout $EXP_BRANCH
git pull
git merge master --no-edit
git add *
git commit -m "automerge"

# Setup IAM role
serverless deploy --verbose

# Shutdown
serverless remove --verbose
git stash --include-untracked

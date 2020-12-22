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
export STARTLINE=$(grep -n "endpoint" output.txt | cut -d: -f1)
export POST=$(sed -n '27p' < output.txt | cut -b 10-)
export GET=$(sed -n '29p' < output.txt | cut -b 9-)
echo $POST
echo $GET
sleep 3000

# Shutdown
serverless remove
git stash --include-untracked

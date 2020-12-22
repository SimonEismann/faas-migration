#!/bin/sh

export GIT_MERGE_AUTOEDIT=no
git pull
git checkout $EXP_BRANCH
git pull
git merge master --no-edit
git add *
git commit -m "automerge"

# Deploy
npm install
serverless deploy | tee output.txt

# Collect output
export STARTLINE=$(grep -n "endpoint" output.txt | cut -d: -f1)
export POST=$(sed -n '27p' < output.txt | cut -b 10-)
export GET=$(sed -n '29p' < output.txt | cut -b 9-)
export GET2=$(sed -n '28p' < output.txt | cut -b 9-)

# Configure load script
sed -i "s@URL1PLACEHOLDER@$POST@g" load.lua
sed -i "s@URL2PLACEHOLDER@$GET@g" load.lua
sed -i "s@URL3PLACEHOLDER@$GET2@g" load.lua

# Run Load
java -jar httploadgenerator.jar loadgenerator > loadlogs.txt 2>&1 &
chmod 777 generateConstantLoad.sh
./generateConstantLoad.sh $EXP_LOAD $EXP_DURATION
sleep 10
java -jar httploadgenerator.jar director --ip localhost --load load.csv -o results.csv --lua load.lua --randomize-users -t $EXP_THREATS

# TODO
sleep 300000

# Shutdown
serverless remove
git stash --include-untracked


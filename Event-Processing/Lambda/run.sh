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
export LINE=$(grep -n "/ingest" output.txt | cut -d: -f1)
export POST=$(sed -n "${LINE}p" < output.txt | cut -b 10-)
export LINE=$(grep -n "/latest" output.txt | cut -d: -f1)
export GET=$(sed -n "${LINE}p" < output.txt | cut -b 9-)
export LINE=$(grep -n "/list" output.txt | cut -d: -f1)
export GET2=$(sed -n "${LINE}p" < output.txt | cut -b 9-)

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
echo "duration,maxRss,fsRead,fsWrite,vContextSwitches,ivContextSwitches,userDiff,sysDiff,rss,heapTotal,heapUsed,external,elMin,elMax,elMean,elStd,bytecodeMetadataSize,heapPhysical,heapAvailable,heapLimit,mallocMem,netByRx,netPkgRx,netByTx,netPkgTx" > eventinserter.csv
aws dynamodb scan --table-name long.ma.cancel-booking-metrics --query "Items[*].[duration.N,maxRss.N,fsRead.N,fsWrite.N,vContextSwitches.N,ivContextSwitches.N,userDiff.N,sysDiff.N,rss.N,heapTotal.N,heapUsed.N,external.N,elMin.N,elMax.N,elMean.N,elStd.N,bytecodeMetadataSize.N,heapPhysical.N,heapAvailable.N,heapLimit.N,mallocMem.N,netByRx.N,netPkgRx.N,netByTx.N,netPkgTx.N]" --output json | jq -r '.[] | @csv' >> eventinserter.csv
cat eventinserter.csv
sleep 300000

# Shutdown
serverless remove
git stash --include-untracked


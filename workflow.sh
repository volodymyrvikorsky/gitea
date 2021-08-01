#!/bin/bash


# install dependencies

pip3 install awscli --user --upgrade 2> /dev/null
pip3 install awsebcli --user --upgrade 2> /dev/null


# create artifact

#cd ./pixelapp_be
zip -r $ARTIFACT_NAME ./Procfile  ./application ./go.mod
cd mkdir my_gitea_deploy
cd my_gitea_deploy && mv ../$ARTIFACT_NAME ./


# configure awscli

mkdir ~/.aws 2> /dev/null
cat <<EOF > ~/.aws/config
[default]
region = $AWS_APP_REGION
output = json
EOF

cat <<EOF > ~/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY
aws_secret_access_key = $AWS_SECRET_KEY
EOF


# configure config.yml for awsebcli app

mkdir .elasticbeanstalk
cat <<EOF > .elasticbeanstalk/config.yml
branch-defaults:
  default:
    environment: $ENV_NAME
deploy:
  artifact: $ARTIFACT_NAME
global:
  application_name: $APP_NAME
  default_region: $AWS_APP_REGION
EOF


# deploy new version

/root/.local/bin/eb deploy --label "Version-3"
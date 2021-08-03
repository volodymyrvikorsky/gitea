#!/bin/bash

# install awscli & awsebcli

pip3 install awscli --user --upgrade 
pip3 install awsebcli --user --upgrade 

# create artifact

zip -r application.zip ./Procfile  ./application ./go.mod
mkdir my_gitea_deploy
mv ./application.zip ./my_gitea_deploy/
cd my_gitea_deploy

# configure awscli

mkdir ~/.aws 
cat <<EOF > ~/.aws/config
[default]
region = eu-central-1
output = json
EOF

cat <<EOF > ~/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY
aws_secret_access_key = $AWS_SECRET_KEY
EOF


# create config.yml for awsebcli app

mkdir .elasticbeanstalk
cat <<EOF > .elasticbeanstalk/config.yml
branch-defaults:
  default:
    environment: gitea-test-env
deploy:
  artifact: application.zip
global:
  application_name: gitea-test
  default_region: eu-central-1
EOF

# change xginx configuration file

rm -rf ~/etc/nginx/conf.d/elasticbeanstalk/00_application.conf
cat <<EOF > ~/etc/nginx/conf.d/elasticbeanstalk/00_application.conf
proxy_pass          http://127.0.0.1:3000;
    proxy_http_version  1.1;

    proxy_set_header    Connection          $connection_upgrade;
    proxy_set_header    Upgrade             $http_upgrade;
    proxy_set_header    Host                $host;
    proxy_set_header    X-Real-IP           $remote_addr;
    proxy_set_header    X-Forwarded-For     $proxy_add_x_forwarded_for;
EOF


# deploy artifact to beanstalk

/root/.local/bin/eb deploy 
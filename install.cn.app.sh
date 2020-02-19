#!/bin/bash

#NOTES:
# script designed for macos - tested on 10.14.6  
# script uses and expects the following tools to be available:
# *yarn v1.17.3
# *docker 19.03.5
# *go 1.13.6
# *jq 1.6

command -v yarn >/dev/null 2>&1 || { echo >&2 "yarn command is required by this script - install and then rerun..."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo >&2 "docker command is required by this script - install and then rerun..."; exit 1; }
command -v go >/dev/null 2>&1 || { echo >&2 "go command is required by this script - install and then rerun..."; exit 1; }
command -v jq >/dev/null 2>&1 || { echo >&2 "jq command is required by this script - install and then rerun..."; exit 1; }

echo here!
exit 1

mkdir ./cloudnativedemo && cd ./cloudnativedemo

echo cloning...
git clone https://github.com/cloudacademy/voteapp-frontend-react
git clone https://github.com/cloudacademy/voteapp-api-go

echo building frontend...
pushd ./voteapp-frontend-react
cat > .env << EOF
REACT_APP_APIHOSTPORT=localhost:8080
EOF
yarn install
yarn build
docker build -t cloudacademy/frontend:v1 .
popd

echo building api...
pushd ./voteapp-api-go
go get -v
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o api
docker build -t cloudacademy/api:v1 .
popd

echo creating docker network...
docker network create cloudnativedemo
docker network ls
docker network inspect cloudnativedemo

echo creating docker containers...
docker run --name mongo --network cloudnativedemo -d -p 27017:27017 mongo:4.2
docker run --name api --network cloudnativedemo --env MONGO_CONN_STR=mongodb://mongo:27017/langdb -d -p 8080:8080 cloudacademy/api:v1
docker run --name frontend --network cloudnativedemo -d -p 80:80 cloudacademy/frontend:v1

echo getting docker logs...
docker logs mongo
docker logs api
docker logs frontend

echo installing mongo client...
curl -O https://fastdl.mongodb.org/osx/mongodb-shell-macos-x86_64-4.2.0.tgz
tar -xvf mongodb-shell-macos-x86_64-4.2.0.tgz
mv ./mongodb-macos-x86_64-4.2.0/bin/mongo .
chmod +x mongo

echo creating mongodb script...
cat > db.setup.js << EOF
use langdb;
db.languages.insert({"name" : "go", "codedetail" : { "usecase" : "system, web, server-side", "rank" : 16, "compiled" : true, "homepage" : "https://golang.org", "download" : "https://golang.org/dl/", "votes" : 0}});
db.languages.insert({"name" : "java", "codedetail" : { "usecase" : "system, web, server-side", "rank" : 2, "compiled" : true, "homepage" : "https://www.java.com/en/", "download" : "https://www.java.com/en/download/", "votes" : 0}});
db.languages.insert({"name" : "nodejs", "codedetail" : { "usecase" : "system, web, server-side", "rank" : 30, "compiled" : false, "homepage" : "https://nodejs.org/en/", "download" : "https://nodejs.org/en/download/", "votes" : 0}});
db.languages.find().pretty();
EOF

echo executing mongodb script...
./mongo < db.setup.js

echo testing api...
curl -s localhost:8080/ok
curl -s localhost:8080/languages | jq .

echo opening chrome...
open -a /Applications/Google\ Chrome.app http://localhost

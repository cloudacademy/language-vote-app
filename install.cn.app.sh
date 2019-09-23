#!/bin/bash
mkdir ~/cloudnativedemo && cd ~/cloudnativedemo

echo cloning...
git clone https://github.com/cloudacademy/voteapp-frontend-react
git clone https://github.com/cloudacademy/voteapp-api-go

echo building frontend...
cd ~/cloudnativedemo/voteapp-frontend-react
cat > .env << EOF
REACT_APP_APIHOSTPORT=localhost:8080
EOF
yarn install
yarn build
docker build -t cloudacademy/frontend:v1 .

echo building api...
cd ~/cloudnativedemo/voteapp-api-go
go get -v
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o api
docker build -t cloudacademy/api:v1 .

echo creating docker network...
docker network create cloudnativedemo
docker network ls
docker network inspect cloudnativedemo

echo creating docker containers...
docker run --name mongo --network cloudnativedemo -d -p 27017:27017 mongo
docker run --name api --network cloudnativedemo --env MONGO_CONN_STR=mongodb://mongo:27017/langdb -d -p 8080:8080 cloudacademy/api:v1
docker run --name frontend --network cloudnativedemo -d -p 80:80 cloudacademy/frontend:v1

echo getting docker logs...
docker logs mongo
docker logs api
docker logs frontend

echo installing mongo client...
cd ~/cloudnativedemo 
curl -O https://downloads.mongodb.org/osx/mongodb-shell-osx-ssl-x86_64-3.6.2.tgz
tar -xvf mongodb-shell-osx-ssl-x86_64-3.6.2.tgz
cd ./mongodb-osx-x86_64-3.6.2/bin

echo creating mongodb script...
cat > ~/cloudnativedemo/db.setup.js << EOF
use langdb;
db.languages.insert({"name" : "go", "codedetail" : { "usecase" : "system, web, server-side", "rank" : 16, "compiled" : true, "homepage" : "https://golang.org", "download" : "https://golang.org/dl/", "votes" : 0}});
db.languages.insert({"name" : "java", "codedetail" : { "usecase" : "system, web, server-side", "rank" : 2, "compiled" : true, "homepage" : "https://www.java.com/en/", "download" : "https://www.java.com/en/download/", "votes" : 0}});
db.languages.insert({"name" : "nodejs", "codedetail" : { "usecase" : "system, web, server-side", "rank" : 30, "compiled" : false, "homepage" : "https://nodejs.org/en/", "download" : "https://nodejs.org/en/download/", "votes" : 0}});
db.languages.find().pretty();
EOF

echo executing mongodb script...
./mongo < ~/cloudnativedemo/db.setup.js

echo testing api...
cd ~/cloudnativedemo/
curl -s localhost:8080/ok
curl -s localhost:8080/languages | jq .

echo opening chrome...
open -a /Applications/Google\ Chrome.app http://localhost

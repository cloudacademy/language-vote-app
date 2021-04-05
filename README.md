# CloudAcademy + DevOps
This is part of the [CloudAcademy](https://cloudacademy.com/library/) Docker/React/Go/MongoDB Learning Path!

* https://github.com/cloudacademy/voteapp-frontend-react
* https://github.com/cloudacademy/voteapp-api-go

# Background
Provides an end-to-end build and deployment environment to compile and launch the Language Vote App using [Docker](https://www.docker.com/) containers.

# Vagrant
Make sure that you have [Vagrant](https://www.vagrantup.com/) installed, and then simply run the following command to launch:

```
vagrant up
```

This will build an Ubuntu 18.04 server complete with all of the required tools needed by the ```install.cn.app.sh``` script automatically installed:

* go: ```go version go1.15.1 linux/amd64```
* jq: ```jq-1.5-1-a5b5cbe```
* node: ```v8.10.0```
* yarn: ```1.22.5```
* docker: ```Docker version 19.03.12, build 48a66213fe```

Once you have SSH'd into the server (```vagrant ssh```) you can simply perform the following commands to get the whole solution working:

```
cd /vagrant
./install.cn.app.sh
```

Finally, jump into your local browser and browse to:

```
http://localhost
```

The fully dockerised solution will now be presented to you:

![Language Vote Application](/doc/VoteApp.png)

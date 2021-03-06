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
* node: ```v14.17.0```
* yarn: ```1.22.5```
* docker: ```Docker version 20.10.6, build 370c289```

Once the Vagrant box has completed building and is up and running, run the following command to kick off a full installation of the VoteApp 

```
vagrant ssh -c "cd /vagrant && ./install.cn.app.sh"
```

Finally, jump into your local browser and browse to:

```
http://localhost
```

The fully dockerised solution will now be presented to you:

![Language Vote Application](/doc/VoteApp.png)

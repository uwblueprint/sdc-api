# Social Development Centre [![CircleCI](https://circleci.com/gh/uwblueprint/sdc-api/tree/master.svg?style=shield)](https://circleci.com/gh/uwblueprint/sdc-api/tree/master)

## Introduction

This is the web API portion of the Social Development Centre Project for [UW Blueprint](https://https://uwblueprint.org/).

This project was started in Fall 2019 and is currently in development.

**Project Lead:** Daniel Williams - [@ddgwilli](https://github.com/ddgwilli)

**Project Manager:** Leonard Zhang - [@leonardz](https://github.com/leonardz)

**Designers:** 
* Annie Xu
* Carmen Lee

**Developers:** 
* Lee Ma - [@lee-ma](https://github.com/lee-ma)
* Daniel Peng - [@danielpeng2](https://github.com/danielpeng2)
* Ritika Rao - [@ritikarao](https://github.com/ritikarao)
* Megan Niu - [@meganniu](https://github.com/meganniu)
* Jayant Shrivastava - [@jayshrivastava](https://github.com/jayshrivastava)

## Development Setup

**Installing Docker:** 

Please refer to the offical docs at https://docs.docker.com/install/

**Development DB Setup:** 
```
# pull the docker image
docker pull postgres

# run the docker container
docker run -e POSTGRES_PASSWORD=sdcdev -p 5432:5432 -d postgres

# init the database and sample data
rake db:drop db:create db:migrate db:seed

# FYI: This is how to list running docker containers (add -a to list all continers).
docker ps

# FYI: This is how to start/stop containers. You should stop all your containers when you are not developing.
docker start <container id>
docker stop <container id>

```

**Connecting to the Development DB** 
```
# connect to docker container
psql -h localhost -U postgres -d postgres

# go into the sdc database of the postgres server
\c sdc

# you can write any psql statements inside the sdc database 
SELECT * FROM questions;

# you can also use psql commands like this one which lists a table's schema
\d+ questions
```

**Environment Variable Setup**
```
# remove .template from .env.development.local.template and fill in .env.development.local, example values:
CORS_ORIGIN=http://localhost:3000
SEED_USER_EMAIL=test@test.com
SEED_USER_PASSWORD=password
DEVISE_JWT_SECRET_KEY=super_secret_secret_key
```

## Troubleshooting
**(Windows) Bundle Install Fails Due to pg?**
Try the following:
```
sudo apt-get install libpq-dev
gem install pg  --   --with-pg-lib=/usr/lib
bundle install
```
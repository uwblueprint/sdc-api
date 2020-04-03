# Social Development Centre [![CircleCI](https://circleci.com/gh/uwblueprint/sdc-api/tree/master.svg?style=shield)](https://circleci.com/gh/uwblueprint/sdc-api/tree/master)

## Introduction

This is the web API portion of the Social Development Centre Project for [UW Blueprint](https://https://uwblueprint.org/).

This project was started in Fall 2019 and is currently in development.

### Fall 2019 Team

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

### Winter 2020 Team

**Project Lead:** Leon Ouyang - [@LeozMaxwellJilliams](https://github.com/LeozMaxwellJilliams)

**Project Manager:** James Lu

**Designer:** Brandon Law

**Developers:**
* Ainley Pena
* Faizaan Madhani
* Nim Wijetunga
* Patrick Du
* Stephanie Xu


## Development Setup

**Environment Setup**

Pull the repository and navigate into the project root. Make sure
[Ruby](https://www.ruby-lang.org/en/documentation/installation/) and
[Bundler](https://bundler.io) are installed.

```
# install dependencies
bundle install
```

**Installing Docker:** 

Please refer to the offical docs at https://docs.docker.com/install/

**Development DB Setup:** 
```
# pull the docker image
docker pull postgres

# run the docker container
# take note of the password here
docker run -e POSTGRES_PASSWORD=sdcdev -p 5432:5432 -d postgres

# init the database and sample data
rails db:setup

# FYI: This is how to list running docker containers (add -a to list all continers).
docker ps

# FYI: This is how to start/stop containers. You should stop all your containers when you are not developing.
docker start <container id>
docker stop <container id>

```

**Connecting to the Development DB** 
```
# connect to docker container
# find container name using `docker ps` (name is different from id)
# password was set in the command to run the container above
docker exec -it <container name> psql -h localhost -U postgres -d postgres

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

**Authenticating Routes with Devise**
```
# This project includes Devise for auth, add this line before the resource to require a user to be logged in:
before_action :authenticate_user!
```

**Run the dev server**

```
rails s
```

## Deployment

#### Initial Deployment

This app can be best deployed using Heroku. Currently, it is running [here](https://guarded-plains-51025.herokuapp.com). For a new deployment, begin by setting up Heroku account [here](https://heroku.com) and installing the Heroku CLI [here](https://devcenter.heroku.com/articles/heroku-cli).

This app is deployed using the Docker Container Registry on Heroku. To learn more about the Docker Registry go [here](https://docs.docker.com/registry/). The documentation that informed this deployment methodology, can be found [here](https://devcenter.heroku.com/articles/container-registry-and-runtime). Consult it when troubleshooting.

Before starting, ensure that the Docker Daemon is running.

Begin by logging in:

```
heroku login
```

Inside the project folder, to create a new heroku project:

```
heroku create
```

This project uses a PostgreSQL database which will be provisioned using Heroku. This should be automatically provisioned when the app is first created, however, if it is not, consult the Heroku PostgreSQL docs [here](https://devcenter.heroku.com/articles/heroku-postgresql#provisioning-heroku-postgres) to set it up. 

Then, login to the Docker Container Registry:

```
heroku container:login
```

Build the image and push to Container Registry:

```
heroku container:push web
```

Then release the image to your app:

```
heroku container:release web
```

Then, to migrate the database into Heroku's Postgres container, run:

```
heroku run rake db:migrate
```

#### Subsequent Deployments:

Subsequent deployments are much simpler, just run:

```
heroku container:push web
heroku container: release web
```

Occaisionally, you may need to remigrate the database if data has been reseeded:

```
heroku run rake db:migrate
```

## Troubleshooting
**(Windows) Bundle Install Fails Due to pg?**
Try the following:
```
sudo apt-get install libpq-dev
gem install pg  --   --with-pg-lib=/usr/lib
bundle install
```

**Bundle Install fails because bundler cannot be found**

If you get an error during dependency installation containing `can't find gem bundler (>= 0.a) with executable bundle` but bundle is installed, try
```
gem update --system
bundle install
```
This worked with Ruby 2.5.1 with `rbenv` on MacOS.

**Database Errors in Production**

Sometimes, the database in production may be not be working as expected. If reseeding or remigrating the data does not work, another (nuclear) option is to reset the database, which will drop it and reprovision it. Note that this deletes all the data from the database. 

This can be done from the Heroku Postgres Dashboard or by using CLI:
```
heroku pg:reset DATABASE
```
After this, be sure to remigrate the database using:
```
heroku run rake db:migrate
```







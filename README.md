# Social Development Centre

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
* Ritika Rao
* Megan Niu - [@meganniu](https://github.com/meganniu)
* Jayant Shrivastava - [@jayshrivastava](https://github.com/jayshrivastava)

## Set up

#### Database

```
docker pull postgres
docker run -e POSTGRES_PASSWORD=uwblueprintsdc -p 5432:5432 -d postgres
rake db:create # create a database called sdc from rails
rake db:migrate # seed the data in the db
```

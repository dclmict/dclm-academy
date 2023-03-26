<p align="center"><a href="https://dclm.org" target="_blank"><img src="https://dclmcloud.s3.amazonaws.com/img/logo.png" width="206.5" height="190"></a></p>

## DCLM Academy

This app is a learning portal (LMS) that makes use of Moodle

App url: [DCLM Academy](https://academy.dclm.org)

## How to Run
### Docker
- make sure you have [docker](https://www.docker.com/products/docker-desktop/) and [docker compose](https://docs.docker.com/compose/install/) installed
- make sure you have a local database setup
- create a directory: `mkdir -p <directory-name>`
- create database for moodle
- run `git clone https://github.com/dclmict/dclm-academy.git .`
- run `make dev`
- run `make log`

## Credit
App built and released by [DCLM ICT team](https://dclmict.org).

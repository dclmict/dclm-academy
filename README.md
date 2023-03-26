<p align="center"><a href="https://dclm.org" target="_blank"><img src="https://dclmcloud.s3.amazonaws.com/img/logo.png" width="206.5" height="190"></a></p>

## DCLM Academy

This app is a learning portal (LMS) that makes use of Moodle

App url: [DCLM Academy](https://academy.dclm.org)

## How to Run
### Microservices architecture (Docker)
- make sure you have [docker compose](https://docs.docker.com/compose/install/) installed
- make sure [PHP 7.4](https://www.php.net/releases/7_4_0.php) is installed on your server
- make sure you have [composer](https://getcomposer.org/doc/00-intro.md#installation-linux-unix-macos) installed
- create a directory: `mkdir -p <directory-name>`
- run `git clone https://github.com/dclmict/dclm-moodle.git .`
- create a database for moodle
- run `make dev`
- run `make log`

## Credit
App built and released by [DCLM ICT team](https://dclmict.org).

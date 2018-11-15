[![Build Status](https://travis-ci.org/puzzle/mailbox-watcher.svg?branch=master)](https://travis-ci.org/puzzle/mailbox-watcher)

# mailbox-watcher

The Mailbox-Watcher is a web-based mailbox monitoring application,
which checks the mails from different project mailboxes according to
specific rules and returns a report.

Full documentation is found [here](https://github.com/puzzle/mailbox-watcher/blob/master/doc)

## Prerequisites

- Git

- Ruby

- Bundler

## Installation

### Git

What is [Git](https://git-scm.com/)?

### How to install Git on Linux

```
$ sudo apt install git-all
```

### Ruby

Mailbox-Watcher runs on [Ruby 2.4.4](https://www.ruby-lang.org/en/news/2018/03/28/ruby-2-4-4-released/).
You can install [Ruby](https://www.ruby-lang.org/en/) with [RVM](https://rvm.io/).
RVM is a command-line tool which allows you to easily install, manage, and work with multiple ruby environments from interpreters to sets of gems. 

### How to install Ruby 2.4.4 with RVM on Linux

```
$ rvm install ruby-2.4.4
```

### Bundler

```
$ gem install bundler
$ bundle install
```

### How to clone repository

Clone the Mailbox-Watcher repository and change into the new directory:

```
$ git clone https://github.com/puzzle/mailbox-watcher.git
$ cd mailbox-watcher/
```
### How to create Config- and Secret-Files

For watching the mailboxes of a project, you first have to create their config files and configure the project specific settings. There is one config-file and one secret-file per project. The config-file contains one or many mailboxes with different folders and rules. The secret-file contains the mailboxes' hostname and credentials.

How you can configure this project can be found here: [config concept](https://github.com/puzzle/mailbox-watcher/blob/master/doc/2_konzeption/2.3_config_konzept/2.3.1_config_konzept.md).

Place config and secret files in fixtures directory `/home/mzurbuchen/git/mailbox-watcher/development/fixtures`

### Start server in development

```$ rake start```

Starts puma server with Environment-Variables
`MAIL_MON_TOKEN=1234`,
`CONFIG_PATH=./development/fixtures/configs`,
`SECRET_PATH=./development/fixtures/secrets`.

### Frontend Setup

Check out [frontend](frontend)

### Run tests

```$ rake test```

### Run rubocop

```$ rubocop -R```

## Production

Since mailbox watcher is a standard rack application, it can be run with apache/nginx with passenger or with passenger standalone. 

  1. build frontend source (```$ frontend/config/build/build_frontend.sh```)
  1. copy created artifacts to project's public folder (```$ cp -r frontend/dist/* public```)
  1. create required secret/config files
  1. set ENV vars: CONFIG_PATH, SECRET_PATH, MAIL_MON_TOKEN
  1. configure apache/nginx, passenger or use our ruby 2.5 docker image: https://hub.docker.com/r/puzzle/ose3-rails-nodejs
  
## Local Passenger Test

After building/copying the frontend artifacts, you can test it with passenger locally:

```$ gem install passenger```

```$ CONFIG_PATH=~/tmp/mb/config SECRET_PATH=~/tmp/mb/secret  MAIL_MON_TOKEN=1234 passenger start```

## Featurelist

- Monitors several projects with different mailboxes.
- Checks mails for a maximum age.
- Checks mail subjects with a custom regex.
- Generates project page with a report.

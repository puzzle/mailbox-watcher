[![Build Status](https://travis-ci.org/puzzle/mailbox-watcher.svg?branch=master)](https://travis-ci.org/puzzle/mailbox-watcher)

# mailbox-watcher

The Mailbox-Watcher is a web-based mailbox monitoring application,
which checks the mails from different project mailboxes according to
specific rules and returns a report.

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

Bundler provides an environment for Ruby projects by tracking and installing the gems and versions that are needed.

### How to install Bundler on Linux

```
$ gem install bundler
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

Execute bundle install:

```
$ bundle install
```

### Start server

```$ puma```

### Authentication

For the authentication a token must be given.
The first time you visit the web application, a pop-up will appear.
The token you have to pass there must be the same as the environment variable MAIL_MON_TOKEN.
For development, the token can be customized with changing the environment variable.
How the token is generated during deployment and where it is saved can be found [here](https://github.com/puzzle/mailbox-watcher/blob/master/doc/2_konzeption/2.7_authentification_token.md).

### Run tests

```$ rake test```

### Run rubocop

```$ rubocop -R```

## Featurelist

- Monitors several projects with different mailboxes.
- Checks mails for a maximum age.
- Checks mail subjects with a custom regex.
- Generates project page with a report.

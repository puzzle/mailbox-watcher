[![Build Status](https://travis-ci.org/puzzle/mailbox-watcher.svg?branch=master)](https://travis-ci.org/puzzle/mailbox-watcher)

# mailbox-watcher

This Readme explains how to use Mailbox-Watcher.

The Mailbox-Watcher is a web-based mailbox monitoring application,
which checks the mails from different project mailboxes according to
specific rules and returns a report.

## Prerequisites

- Git

- Ruby

- Bundler

## Installation

### Git

Git is a free software for distributed version management of files initiated by Linus Torvalds.

### How to install Git on Linux

```
$ sudo apt install git-all
```

### Ruby

Ruby is an object-oriented programming language.
Mailbox-Watcher runs on [Ruby 2.4.4](https://www.ruby-lang.org/en/news/2018/03/28/ruby-2-4-4-released/).
You can install Ruby with [RVM](https://rvm.io/).
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

Clone Mailbox-Watcher repository and change into the new directory:

```
$ git clone https://github.com/puzzle/mailbox-watcher.git
$ cd mailbox-watcher/
```

Execute bundle install:

```
$ bundle install
```

### Start server

```$ puma```

### Run tests

```$ rake test```

### Run rubocop

```$ rubocop -R```

## Featurelist

- Monitors several projects with different mailboxes
- Checks mails for a maximum age
- Checks mails subject with a regex
- Generates projectsite with report

# mailbox-watcher

This Readme explains how to use Mailbox-Watcher

The Mailbox-Watcher is a web-based mailbox monitoring application,
which checks the mails from different project mailboxes according to
specific rules and returns a report.

## Prerequisites

-Git

-Ruby

-Bundler

## Installation

### Git

Git is a free software for distributed version management of files initiated by Linus Torvalds.

### How to install Git on Linux

```
$ sudo apt install git-all
```

### Ruby

Ruby is an object-oriented programming language

### How to install Ruby on Linux

```
$ sudo apt install ruby
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

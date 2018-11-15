# frozen_string_literal: true

desc 'set environment variables for development'
task :start do
  sh 'MAIL_MON_TOKEN=1234 ' +
    'CONFIG_PATH=./development/fixtures/configs ' +
    'SECRET_PATH=./development/fixtures/secrets ' +
     'puma'
end

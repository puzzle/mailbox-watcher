# frozen_string_literal: true

desc 'Runs the tasks for a commit build and nightly build'
task ci: ['test',
          'rubocop:run',
          'frontend:prepare',
          'frontend:run',
          'lint:hbs',
          'lint:js']

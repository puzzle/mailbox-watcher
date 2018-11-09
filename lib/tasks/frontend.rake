# frozen_string_literal: true

namespace :frontend do
  desc 'prepare for running frontend tests'
  task :prepare do
    sh 'cd frontend && yarn install'
  end

  desc 'run frontend tests'
  task :run do
    sh 'cd frontend && ember test'
  end
end

# frozen_string_literal: true

namespace :rubocop do
  desc 'run rubocop'
  task :run do
    sh 'rubocop -R'
  end
end

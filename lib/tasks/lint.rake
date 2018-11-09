# frozen_string_literal: true

namespace :lint do
  desc 'run hbs lint'
  task :hbs do
    sh 'cd frontend && yarn run lint:hbs'
  end

  desc 'run js lint'
  task :js do
    sh 'cd frontend && yarn run lint:js'
  end
end

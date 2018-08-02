# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require File.expand_path('src/app', File.dirname(__FILE__))
run App

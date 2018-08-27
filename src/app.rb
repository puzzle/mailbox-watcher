# frozen_string_literal: true

require 'yaml'
require 'sinatra'
require 'sinatra/flash'
require 'json'
require 'haml'
require_relative 'lib/imap_connector'
require_relative 'lib/config_reader'
require_relative 'steps/check_token'
require_relative 'steps/prepare'
require_relative 'steps/check_mailbox'
require_relative 'steps/generate_report'

class App < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  
  # start server: puma

  # work in progress
  get '/test-config' do
    p = Prepare.new('cryptopus')
    project = p.execute
    return 404, p.errors if project.nil?

    c = CheckMailbox.new(project)
    c.execute

    g = GenerateReport.new(project)
    g.execute

    return 200, 'test'
  end
  
  get '/flash-message' do
    flash[:danger] = 'This is an error'
    @projectnames = ['projectname']
    haml :index
  end

  # work in progress
  get '/test-token/:token' do
    token = params['token']
    ct = CheckToken.new(token)
    # raises when token is invalid
    return 401, ct.errors unless ct.execute
    p = Prepare.new('cryptopus')
    project = p.execute
    c = CheckMailbox.new(project)
    c.execute
    return 200, 'test'
  end
end

# frozen_string_literal: true

require 'yaml'
require 'sinatra'
require_relative 'lib/imap_connector'
require_relative 'lib/config_reader'

class App < Sinatra::Base
  # start server: puma

  get '/test-config' do
    config = YAML.load_file('config/cryptopus.yml')
    imap_connector = ImapConnector.new(username: 'username',
                                       password: 'password',
                                       hostname: 'hostname.example.com',
                                       ssl: true)
    imap_connector = ImapConnector.new(username: 'username', password: 'password', hostname: 'hostname.example.com', ssl: true)
    imap_connector.authenticate
    return 200, config['description']
  end
end

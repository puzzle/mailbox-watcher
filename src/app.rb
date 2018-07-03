require 'yaml'
require 'sinatra'

class App < Sinatra::Base

  # start server: puma

  get '/test-config' do
    config = YAML.load_file('config/cryptopus.yml')
    return 200, config['description']
  end
end

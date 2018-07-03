require 'test/unit'
require 'rack/test'
require_relative '../app'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_sinatra_dont_know_this_ditty
    get '/bla'
    assert_equal 404, last_response.status
  end
end

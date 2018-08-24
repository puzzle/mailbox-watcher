# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../steps/check_token'

class CheckTokenTest < Test::Unit::TestCase
  context 'check token sent' do
    def test_token_valid
      check_token = CheckToken.new('valid_token')
      check_token.expects(:token)
                 .returns('valid_token')

      assert_equal true, check_token.execute
      assert_equal [], check_token.errors
      assert_equal 200, check_token.state
    end

    def test_token_invalid
      check_token = CheckToken.new('invalid_token')
      check_token.expects(:token)
                 .returns('valid_token')

      assert_equal false, check_token.execute
      assert_equal 'Authentication with invalid token failed',
                   check_token.errors.first
      assert_equal 401, check_token.state
    end
  end
end

# frozen_string_literal: true

require 'test/unit'
require 'rack/test'
require_relative '../app'
require_relative 'test_helper'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    App.new
  end

  context 'status' do
    def test_sinatra_does_not_know_this_ditty
      get '/not_existing_route'

      assert_equal 401, last_response.status
    end

    def test_status_project_does_not_exist
      CheckToken.any_instance.expects(:valid?).returns(true)

      get '/status?token=1234&id=not-existing-project'

      assert_equal 404, last_response.status
    end

    def test_status_project_without_errors
      CheckToken.any_instance.expects(:valid?).returns(true)
      Prepare.any_instance.expects(:execute).returns(true)
      CheckMailbox.any_instance.expects(:execute).returns(nil)
      GenerateReport.any_instance.expects(:execute).returns(nil)
      JSON.expects(:parse).returns(project_hash(%w[ok ok ok]))

      get '/status?token=1234&id=project-without-errors'

      assert_equal 200, last_response.status
    end

    def test_status_project_with_errors_in_second_and_fourth_mailbox
      CheckToken.any_instance.expects(:execute).returns(true)
      Prepare.any_instance.expects(:execute).returns(true)
      CheckMailbox.any_instance.expects(:execute).returns(nil)
      GenerateReport.any_instance.expects(:execute).returns(nil)
      JSON.expects(:parse).returns(project_hash(%w[ok error ok error]))

      get '/status?token=1234&id=project-without-errors'

      assert_equal 500, last_response.status
    end

    def test_status_project_with_errors_in_first_and_second_mailbox
      CheckToken.any_instance.expects(:execute).returns(true)
      Prepare.any_instance.expects(:execute).returns(true)
      CheckMailbox.any_instance.expects(:execute).returns(nil)
      GenerateReport.any_instance.expects(:execute).returns(nil)
      JSON.expects(:parse).returns(project_hash(%w[error error ok ok]))

      get '/status?token=1234&id=project-without-errors'

      assert_equal 500, last_response.status
    end
  end

  private

  def project_hash(states)
    {
      'mailboxes' => mailboxes_hash(states)
    }
  end

  def mailboxes_hash(states)
    states.collect.with_index do |status, id|
      {
        'name' => "mailbox#{id}",
        'status' => status
      }
    end
  end
end

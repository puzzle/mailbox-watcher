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

  def setup
    CheckToken.any_instance.stubs(:valid?).returns(true)
  end

  context 'api' do
    def test_returns_projectnames_as_json
      projects = %w[project1 project2 project3]

      ConfigReader.any_instance.expects(:projectnames).returns(projects)
      get '/api/projects'

      assert_equal projectnames_json(projects), last_response.body
      assert_equal 200, last_response.status
    end

    def test_returns_projectdata_as_json
      Prepare.any_instance.expects(:execute).returns(project)
      CheckMailbox.any_instance.expects(:execute).returns(nil)

      gr = GenerateReport.new(project)
      get '/api/projects/project1'

      assert_equal gr.execute, last_response.body
      assert_equal 200, last_response.status
    end

    def test_does_not_return_projectdata_as_json_if_project_does_not_exist
      get '/api/projects/not-existing-project'

      assert_equal 404, last_response.status
    end
  end

  context 'status' do
    def test_status_project_does_not_exist
      CheckToken.any_instance.expects(:valid?).returns(true)

      get '/status?token=1234&id=not-existing-project'

      assert_equal 404, last_response.status
    end

    def test_status_project_without_errors
      Prepare.any_instance.expects(:execute).returns(true)
      CheckMailbox.any_instance.expects(:execute).returns(nil)
      GenerateReport.any_instance.expects(:execute).returns(nil)
      JSON.expects(:parse).returns(project_hash(%w[ok ok ok]))

      get '/status?token=1234&id=project-without-errors'

      assert_equal 200, last_response.status
    end

    def test_status_project_with_errors_in_second_and_fourth_mailbox
      Prepare.any_instance.expects(:execute).returns(true)
      CheckMailbox.any_instance.expects(:execute).returns(nil)
      GenerateReport.any_instance.expects(:execute).returns(nil)
      JSON.expects(:parse).returns(project_hash(%w[ok error ok error]))

      get '/status?token=1234&id=project-without-errors'

      assert_equal 500, last_response.status
    end

    def test_status_project_with_errors_in_first_and_second_mailbox
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

  def project
    Project.new('project1',
                mailboxes,
                'This is a project-description')
  end

  def mailboxes
    [Mailbox.new('mailbox1',
                 folders,
                 imap_config,
                 'This is a mailbox-description')]
  end

  def folders
    [Folder.new('folder1',
                2,
                '(Alert)',
                'This is a folder-description')]
  end

  def imap_config
    ImapConfig.new(mailboxname: 'mailbox1',
                   username: base64_username,
                   password: base64_password,
                   hostname: 'hostname.example.com',
                   options: { port: 144, ssl: true })
  end

  def base64_username
    Base64.encode64('user')
  end

  def base64_password
    Base64.encode64('password')
  end

  def projectnames_json(projects)
    JSON.generate('data': projectnames_hash(projects))
  end

  def projectnames_hash(projects)
    projects.collect do |project|
      {
        'type' => 'project',
        'id' => project,
        'attributes' => {
          'projectname' => project
        }
      }
    end
  end
end

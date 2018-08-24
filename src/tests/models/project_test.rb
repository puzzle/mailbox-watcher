# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../models/folder'
require_relative '../../models/mailbox'
require_relative '../../models/project'

class ProjectTest < Test::Unit::TestCase
  context 'validate project' do
    def test_project_valid
      assert_equal [], project.errors
    end

    def test_project_invalid_if_mailboxes_empty
      project_without_mailboxes = Project.new('project1', 'This is project-description', [])
      assert_equal 'Mailboxes in project project1 are not valid', project_without_mailboxes.errors.first
    end
  end

  private

  def folders
    [Folder.new('folder1',
                'This is a folder-description',
                2,
                '/(Error|Failure)/')]
  end

  def imap_config
    ImapConfig.new(mailboxname: 'mailbox1',
                   username: base64_username,
                   password: base64_password,
                   hostname: 'hostname.example.com',
                   port: 144,
                   ssl: true)
  end

  def mailboxes
    [Mailbox.new('mailbox1',
                 description = 'This is a mailbox-description',
                 folders,
                 imap_config)]
  end

  def project
    Project.new('project1',
                'This is a project-description',
                mailboxes)
  end

  def base64_username
    Base64.encode64('user')
  end

  def base64_password
    Base64.encode64('password')
  end
end

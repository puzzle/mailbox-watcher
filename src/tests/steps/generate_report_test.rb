# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../steps/generate_report'

class GenerateReportTest < Test::Unit::TestCase
  context 'generate report' do
    def test_generate_report
      generate_report_step = GenerateReport.new(project)
      report_json = generate_report_step.execute

      report = JSON.parse(report_json)
      mailbox = report['mailboxes'].first
      folder = mailbox['folders'].first
      mail = folder['alert-mails'].first

      assert_equal 'project1', report['projectname']
      assert_equal 'This is a project-description', report['description']

      assert_equal 'mailbox1', mailbox['name']
      assert_equal 'This is a mailbox-description', mailbox['description']
      assert_equal 'error', mailbox['status']

      assert_equal 'folder1', folder['name']
      assert_equal 'This is a folder-description', folder['description']
      assert_equal '2h', folder['max-age']
      assert_equal '(Error|Failure)', folder['alert-regex']
      assert_equal 1, folder['number-of-mails']
      assert_equal 'Latest mail is older than 42 hours', folder['alerts'].first

      assert_equal 'Error appeared', mail['subject']
      assert_equal 'user1@example.com', mail['sender']
      assert_equal '18.07.2018', mail['received-at']
    end
  end

  private

  def project
    Project.new('project1',
                'This is a project-description',
                mailboxes)
  end

  def mailboxes
    mailbox = Mailbox.new('mailbox1',
                          'This is a mailbox-description',
                          folders,
                          imap_config)
    mailbox.status = 'error'
    [mailbox]
  end

  def folders
    folder = Folder.new('folder1',
                        'This is a folder-description',
                        2,
                        '(Error|Failure)')
    folder.number_of_mails = 1
    folder.alert_mails << mail
    folder.errors << 'Latest mail is older than 42 hours'
    [folder]
  end

  def mail
    Mail.new('Error appeared',
             'user1@example.com',
             'Wed, 18 Jul 2018 08:00:00 -0700')
  end

  def imap_config
    ImapConfig.new(mailboxname: 'mailbox1',
                   username: base64_username,
                   password: base64_password,
                   hostname: 'hostname.example.com',
                   port: 144,
                   ssl: true)
  end

  def base64_username
    Base64.encode64('user')
  end

  def base64_password
    Base64.encode64('password')
  end
end

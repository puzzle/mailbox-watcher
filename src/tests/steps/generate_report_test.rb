# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../steps/generate_report'

class GenerateReportTest < Test::Unit::TestCase
  context 'generate report' do
    def test_generate_report
      generate_report_step = GenerateReport.new(project)
      report_json = generate_report_step.execute

      report = JSON.parse(report_json)
      included = report['included']
      project_data = report['data']
      mailbox = included.first
      folder = included.last
      mail = included[1]

      assert_equal 'project', project_data['type']
      assert_equal 'project1', project_data['id']
      assert_equal 'project1', project_data['attributes']['projectname']
      assert_equal 'This is a project-description', project_data['attributes']['description']
      assert_equal ['An error appeared in the project'], project_data['attributes']['alerts']
      assert_equal 'mailbox1', project_data['relationships'].first['mailbox']['data']['id']

      assert_equal 'mailbox', mailbox['type']
      assert_equal 'mailbox1', mailbox['id']
      assert_equal 'mailbox1', mailbox['attributes']['name']
      assert_equal 'This is a mailbox-description', mailbox['attributes']['description']
      assert_equal 'error', mailbox['attributes']['status']
      assert_equal ['An error appeared in the mailbox'], mailbox['attributes']['alerts']
      assert_equal 'folder1', mailbox['relationships']['folders']['data'].first['id']
      assert_equal 'project1', mailbox['relationships']['project']['data']['id']

      assert_equal 'folder', folder['type']
      assert_equal 'folder1', folder['id']
      assert_equal 'folder1', folder['attributes']['name']
      assert_equal 'This is a folder-description', folder['attributes']['description']
      assert_equal '2h', folder['attributes']['max-age']
      assert_equal '(Error|Failure)', folder['attributes']['alert-regex']
      assert_equal 1, folder['attributes']['number-of-mails']
      assert_equal 'Latest mail is older than 42 hours', folder['attributes']['alerts'].first
      assert_equal 'Error appearedWed, 18 Jul 2018 08:00:00 -0700',
                   folder['relationships']['mails']['data'].first['id']
      assert_equal 'mailbox1', folder['relationships']['mailbox']['data']['id']

      assert_equal 'mail', mail['type']
      assert_equal 'Error appearedWed, 18 Jul 2018 08:00:00 -0700', mail['id']
      assert_equal 'Error appeared', mail['attributes']['subject']
      assert_equal 'user1@example.com', mail['attributes']['sender']
      assert_equal '15:00, 18.07.2018', mail['attributes']['received-at']
      assert_equal 'folder1', mail['relationships']['folder']['data']['id']
    end
  end

  private

  def project
    project = Project.new('project1',
                          mailboxes,
                          'This is a project-description')
    project.errors << 'An error appeared in the project'
    project
  end

  def mailboxes
    mailbox = Mailbox.new('mailbox1',
                          folders,
                          imap_config,
                          'This is a mailbox-description')
    mailbox.status = 'error'
    mailbox.errors << 'An error appeared in the mailbox'
    [mailbox]
  end

  def folders
    folder = Folder.new('folder1',
                        2,
                        '(Error|Failure)',
                        'This is a folder-description')
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
                   options: { port: 144, ssl: true })
  end

  def base64_username
    Base64.encode64('user')
  end

  def base64_password
    Base64.encode64('password')
  end
end

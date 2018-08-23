# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../models/project'
require_relative '../../models/mailbox'
require_relative '../../models/imap_config'
require_relative '../../models/folder'
require_relative '../../lib/imap_connector'
require_relative '../../steps/check_mailbox'

class CheckMailboxTest < Test::Unit::TestCase
  context 'check age' do
    def test_mail_older_than_max_age
      @folders = [Folder.new('folder1',
                             'This is a folder-description',
                             4,
                             nil)]

      ImapConnector.any_instance
                   .expects(:most_recent_mail_date)
                   .returns(Time.now - 6 * 3600)

      check_mailbox_step = CheckMailbox.new(project)

      assert_equal false, check_mailbox_step.execute
      assert_equal ['Latest mail older than 6 hours'], @folders.first.errors
      assert_equal 404, check_mailbox_step.state
    end

    def test_mail_younger_than_max_age
      @folders = [Folder.new('folder1',
                             'This is a folder-description',
                             4,
                             nil)]

      ImapConnector.any_instance
                   .expects(:most_recent_mail_date)
                   .returns(Time.now - 3 * 3600)

      check_mailbox_step = CheckMailbox.new(project)

      assert_equal true, check_mailbox_step.execute
      assert_equal [], @folders.first.errors
      assert_equal 200, check_mailbox_step.state
    end
  end

  context 'check subject' do
    def test_mail_subject_matches_regex
      @folders = [Folder.new('folder1',
                             'This is a folder-description',
                             nil,
                             '(Error)')]

      ImapConnector.any_instance
                   .expects(:mails_from_folder)
                   .with('folder1')
                   .returns([1, 2])

      mail1 = mock('mail1')
      mail1.expects(:subject)
           .returns('Everything ok')
      ImapConnector.any_instance
                   .expects(:mail)
                   .with('folder1', 1)
                   .returns(mail1)

      mail2 = mock('mail2')
      mail2.expects(:subject)
           .returns('Error appeared')
           .times(2)
      mail2.expects(:date)
           .returns('Wed, 18 Jul 2018 08:00:00 -0700')
      mail2.expects(:from)
           .returns(net_imap_address)
      ImapConnector.any_instance
                   .expects(:mail)
                   .with('folder1', 2)
                   .returns(mail2)
      
      check_mailbox_step = CheckMailbox.new(project)
      assert_equal false, check_mailbox_step.execute
      assert_equal 'Error appeared', @folders.first.alert_mails.first.subject
      assert_equal 404, check_mailbox_step.state
    end

    def test_mail_subject_does_not_match_regex
      @folders = [Folder.new('folder1',
                             'This is a folder-description',
                             nil,
                             '(Error)')]

      ImapConnector.any_instance
                   .expects(:mails_from_folder)
                   .with('folder1')
                   .returns([1, 2])

      mail1 = mock('mail1')
      mail1.expects(:subject)
           .returns('Everything ok')
      ImapConnector.any_instance
                   .expects(:mail)
                   .with('folder1', 1)
                   .returns(mail1)

      mail2 = mock('mail2')
      mail2.expects(:subject)
           .returns('Hello Bob')
      ImapConnector.any_instance
                   .expects(:mail)
                   .with('folder1', 2)
                   .returns(mail2)

      check_mailbox_step = CheckMailbox.new(project)
      assert_equal true, check_mailbox_step.execute
      assert_equal [], @folders.first.alert_mails
      assert_equal 200, check_mailbox_step.state
    end
  end

  context 'check subject and age' do
    def test_subject_and_regex_not_defined
      @folders = [Folder.new('folder1',
                             'This is a folder-description',
                             nil,
                             nil)]

      check_mailbox_step = CheckMailbox.new(project)
      assert_equal false, check_mailbox_step.execute
      assert_equal ['Rules in folder folder1 are not valid'],
                   @folders.first.errors
      assert_equal 404, check_mailbox_step.state
    end
  end

  context 'check 2 mailboxes' do
    def test_check_two_valid_mailboxes
      folders1 = [Folder.new('folder1',
                             'This is a folder-description',
                             10,
                             '(Error)')]

      folders2 = [Folder.new('folder2',
                             'This is a folder-description',
                             10,
                             '(Error)')]

      mailboxes2 = [Mailbox.new('mailbox1',
                     description = 'This is a mailbox-description',
                     folders1,
                     imap_config),
                    Mailbox.new('mailbox2',
                     description = 'This is a mailbox-description',
                     folders2,
                     imap_config)]

      project2 = Project.new('project2',
                             'This is a project-description',
                              mailboxes2)

      ImapConnector.any_instance
                   .expects(:mails_from_folder)
                   .with('folder1')
                   .returns([1, 2])
      
      ImapConnector.any_instance
                   .expects(:mails_from_folder)
                   .with('folder2')
                   .returns([1])

      mail1 = mock('mail1')
      mail1.expects(:subject)
           .returns('Everything ok')
      ImapConnector.any_instance
                   .expects(:mail)
                   .with('folder1', 1)
                   .returns(mail1)

      mail2 = mock('mail2')
      mail2.expects(:subject)
           .returns('Hello Bob')
      ImapConnector.any_instance
                   .expects(:mail)
                   .with('folder1', 2)
                   .returns(mail2)
      
      mail3 = mock('mail3')
      mail3.expects(:subject)
           .returns('Hello Alice')
      ImapConnector.any_instance
                   .expects(:mail)
                   .with('folder2', 1)
                   .returns(mail3)
      
      ImapConnector.any_instance
                   .expects(:most_recent_mail_date)
                   .returns(Time.now - 3 * 3600)
                   .times(2)

      check_mailbox_step = CheckMailbox.new(project2)
      assert_equal true, check_mailbox_step.execute
      assert_equal [], folders1.first.alert_mails
      assert_equal [], folders2.first.alert_mails
      assert_equal 200, check_mailbox_step.state
    end
  end

  private

  def imap_connector
    @imap_connector ||= ImapConnector.new(imap_config)
  end

  def project
    Project.new('project1',
                'This is a project-description',
                mailboxes)
  end
  
  def mailboxes
    [Mailbox.new('mailbox1',
                 description = 'This is a mailbox-description',
                 @folders,
                 imap_config)]
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

  def net_imap_address
      mail_address = Net::IMAP::Address.new
      mail_address.name = 'Bob'
      [mail_address]
  end
end

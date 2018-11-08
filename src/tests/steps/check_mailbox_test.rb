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
                             4,
                             nil,
                             'This is a folder description')]

      ImapConnector.any_instance
                   .expects(:most_recent_mail_date)
                   .returns(Time.now - 6 * 3600)
      ImapConnector.any_instance
                   .expects(:mails_from_folder)
                   .with('folder1')
                   .returns([1, 2])

      check_mailbox_step = CheckMailbox.new(project)

      assert_equal false, check_mailbox_step.execute
      assert_equal ['Latest mail older than 6 hours'], @folders.first.errors
      assert_equal 404, check_mailbox_step.state
    end

    def test_mail_younger_than_max_age
      @folders = [Folder.new('folder1',
                             4,
                             nil,
                             'This is a folder description')]

      ImapConnector.any_instance
                   .expects(:most_recent_mail_date)
                   .returns(Time.now - 3 * 3600)
      ImapConnector.any_instance
                   .expects(:mails_from_folder)
                   .with('folder1')
                   .returns([1, 2])

      check_mailbox_step = CheckMailbox.new(project)

      assert_equal true, check_mailbox_step.execute
      assert_equal [], @folders.first.errors
      assert_equal 200, check_mailbox_step.state
    end
  end

  context 'check subject' do
    def test_mail_subject_matches_regex
      @folders = [Folder.new('folder1',
                             nil,
                             '(Error)',
                             'This is a folder description')]

      ImapConnector.any_instance
                   .expects(:mails_from_folder)
                   .with('folder1')
                   .returns([1, 2])

      mail1 = mock('mail1')
      mail1_envelope = mock('mail1_envelope')
      mail1.expects(:attr)
           .returns(mail1_envelope)
      mail1_envelope.expects(:[])
                    .with('ENVELOPE')
                    .returns(mail1_envelope)
      mail1_envelope.expects(:subject)
                    .returns('Everything ok')

      mail2 = mock('mail2')
      mail2_envelope = mock('mail2_envelope')
      mail2.expects(:attr)
           .returns(mail2_envelope)
      mail2_envelope.expects(:[])
                    .with('ENVELOPE')
                    .returns(mail2_envelope)
      mail2_envelope.expects(:subject)
                    .returns('Error')
                    .times(2)
      mail2_envelope.expects(:date)
                    .returns('01.01.2000')
      sender = mock('sender')
      mail2_envelope.expects(:from)
                    .returns([sender])
      sender.expects(:name)
            .returns('Sender')

      ImapConnector.any_instance
                   .expects(:mails)
                   .with('folder1', [1, 2])
                   .returns([mail1, mail2])

      check_mailbox_step = CheckMailbox.new(project)

      assert_equal false, check_mailbox_step.execute
      assert_equal ['Alert regex (Error) matches ' \
                    'with at least one mail in folder folder1'],
                   @folders.first.errors
      assert_equal 404, check_mailbox_step.state
    end

    def test_mail_subject_does_not_match_regex
      @folders = [Folder.new('folder1',
                             nil,
                             '(Error)',
                             'This is a folder description')]

      ImapConnector.any_instance
                   .expects(:mails_from_folder)
                   .with('folder1')
                   .returns([1, 2])

      mail1 = mock('mail1')
      mail1_envelope = mock('mail1_envelope')
      mail1.expects(:attr)
           .returns(mail1_envelope)
      mail1_envelope.expects(:[])
                    .with('ENVELOPE')
                    .returns(mail1_envelope)
      mail1_envelope.expects(:subject)
                    .returns('Everything ok')

      ImapConnector.any_instance
                   .expects(:mails)
                   .with('folder1', [1, 2])
                   .returns([mail1])
      check_mailbox_step = CheckMailbox.new(project)
      assert_equal true, check_mailbox_step.execute
      assert_equal [], @folders.first.errors
      assert_equal 200, check_mailbox_step.state
    end
  end

  context 'check subject and age' do
    def test_mail_older_than_max_age_and_subject_does_not_match
      @folders = [Folder.new('folder1',
                             4,
                             '(Error)',
                             'This is a folder description')]

      ImapConnector.any_instance
                   .expects(:mails_from_folder)
                   .with('folder1')
                   .returns([1, 2])

      mail1 = mock('mail1')
      mail1_envelope = mock('mail1_envelope')
      mail1.expects(:attr)
           .returns(mail1_envelope)
      mail1_envelope.expects(:[])
                    .with('ENVELOPE')
                    .returns(mail1_envelope)
      mail1_envelope.expects(:subject)
                    .returns('Everything ok')

      ImapConnector.any_instance
                   .expects(:mails)
                   .with('folder1', [1, 2])
                   .returns([mail1])

      ImapConnector.any_instance
                   .expects(:most_recent_mail_date)
                   .returns(Time.now - 6 * 3600)

      check_mailbox_step = CheckMailbox.new(project)

      assert_equal false, check_mailbox_step.execute
      assert_equal ['Latest mail older than 6 hours'], @folders.first.errors
      assert_equal 404, check_mailbox_step.state
    end

    def test_mail_younger_than_max_age_and_subject_does_match
      @folders = [Folder.new('folder1',
                             4,
                             '(Error)',
                             'This is a folder description')]

      ImapConnector.any_instance
                   .expects(:mails_from_folder)
                   .with('folder1')
                   .returns([1, 2])

      mail1 = mock('mail1')
      mail1_envelope = mock('mail1_envelope')
      mail1.expects(:attr)
           .returns(mail1_envelope)
      mail1_envelope.expects(:[])
                    .with('ENVELOPE')
                    .returns(mail1_envelope)
      mail1_envelope.expects(:subject)
                    .returns('Error')
                    .times(2)

      sender = mock('sender')
      mail1_envelope.expects(:from)
                    .returns([sender])
      sender.expects(:name)
            .returns('Sender')
      mail1_envelope.expects(:date)
                    .returns('01.01.2000')
      ImapConnector.any_instance
                   .expects(:mails)
                   .with('folder1', [1, 2])
                   .returns([mail1])

      ImapConnector.any_instance
                   .expects(:most_recent_mail_date)
                   .returns(Time.now - 3 * 3600)

      check_mailbox_step = CheckMailbox.new(project)

      assert_equal false, check_mailbox_step.execute
      assert_equal ['Alert regex (Error) matches ' \
                    'with at least one mail in folder folder1'],
                   @folders.first.errors
      assert_equal 404, check_mailbox_step.state
    end

    def test_mail_older_than_max_age_and_subject_does_match
      @folders = [Folder.new('folder1',
                             4,
                             '(Error)',
                             'This is a folder description')]

      ImapConnector.any_instance
                   .expects(:mails_from_folder)
                   .with('folder1')
                   .returns([1, 2])

      mail1 = mock('mail1')
      mail1_envelope = mock('mail1_envelope')
      mail1.expects(:attr)
           .returns(mail1_envelope)
      mail1_envelope.expects(:[])
                    .with('ENVELOPE')
                    .returns(mail1_envelope)
      mail1_envelope.expects(:subject)
                    .returns('Error')
      mail1_envelope.expects(:subject)
                    .returns('Error')
      mail1_envelope.expects(:date)
                    .returns('01.01.2000')
      sender = mock('sender')
      mail1_envelope.expects(:from)
                    .returns([sender])
      sender.expects(:name)
            .returns('Sender')

      ImapConnector.any_instance
                   .expects(:mails)
                   .with('folder1', [1, 2])
                   .returns([mail1])

      ImapConnector.any_instance
                   .expects(:most_recent_mail_date)
                   .returns(Time.now - 6 * 3600)

      check_mailbox_step = CheckMailbox.new(project)

      assert_equal false, check_mailbox_step.execute
      assert_equal ['Alert regex (Error) matches ' \
                    'with at least one mail in folder folder1',
                    'Latest mail older than 6 hours'],
                   @folders.first.errors
      assert_equal 404, check_mailbox_step.state
    end

    def test_mail_younger_than_max_age_and_subject_does_not_match
      @folders = [Folder.new('folder1',
                             4,
                             '(Error)',
                             'This is a folder description')]

      ImapConnector.any_instance
                   .expects(:mails_from_folder)
                   .with('folder1')
                   .returns([1, 2])

      mail1 = mock('mail1')
      mail1_envelope = mock('mail1_envelope')
      mail1.expects(:attr)
           .returns(mail1_envelope)
      mail1_envelope.expects(:[])
                    .with('ENVELOPE')
                    .returns(mail1_envelope)
      mail1_envelope.expects(:subject)
                    .returns('Everything ok')

      ImapConnector.any_instance
                   .expects(:mails)
                   .with('folder1', [1, 2])
                   .returns([mail1])

      ImapConnector.any_instance
                   .expects(:most_recent_mail_date)
                   .returns(Time.now - 6 * 3600)

      check_mailbox_step = CheckMailbox.new(project)

      assert_equal false, check_mailbox_step.execute
      assert_equal ['Latest mail older than 6 hours'], @folders.first.errors
      assert_equal 404, check_mailbox_step.state
    end

    def test_max_age_and_regex_not_defined
      @folders = [Folder.new('folder1',
                             nil,
                             nil,
                             'This is a folder description')]
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
                             10,
                             nil,
                             'This is a folder description')]

      folders2 = [Folder.new('folder2',
                             10,
                             nil,
                             'This is a folder-description')]

      mailboxes2 = [Mailbox.new('mailbox1',
                                folders1,
                                imap_config,
                                'This is a mailbox-description'),
                    Mailbox.new('mailbox2',
                                folders2,
                                imap_config,
                                'This is a mailbox-description')]

      project2 = Project.new('project2',
                             mailboxes2,
                             'This is a project-description')

      ImapConnector.any_instance
                   .expects(:mails_from_folder)
                   .with('folder1')
                   .returns([1, 2])

      ImapConnector.any_instance
                   .expects(:mails_from_folder)
                   .with('folder2')
                   .returns([1])

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
                mailboxes,
                'This is a project-description')
  end

  def mailboxes
    [Mailbox.new('mailbox1',
                 @folders,
                 imap_config,
                 'This is a mailbox-description')]
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

  def net_imap_address
    mail_address = Net::IMAP::Address.new
    mail_address.name = 'Bob'
    [mail_address]
  end
end

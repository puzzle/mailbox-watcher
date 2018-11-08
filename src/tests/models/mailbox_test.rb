# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../models/folder'
require_relative '../../models/mailbox'

class MailboxTest < Test::Unit::TestCase
  context 'validate mailbox' do
    def test_mailbox_valid
      imap_config = ImapConfig.new(mailboxname: 'mailboxname',
                                   username: 'user',
                                   password: 'password',
                                   hostname: 'example.hostname.com')
      folders = [Folder.new('folder1',
                            2,
                            '/(Error|Failure)/',
                            'this is a folder description')]

      mailbox = Mailbox.new('mailbox1',
                            folders,
                            imap_config,
                            'this is a mailbox description')
      assert_equal [], mailbox.errors
    end

    def test_mailbox_invalid_if_folders_empty
      imap_config = ImapConfig.new(mailboxname: 'mailboxname',
                                   username: 'user',
                                   password: 'password',
                                   hostname: 'example.hostname.com')
      mailbox = Mailbox.new('mailbox1',
                            [],
                            imap_config,
                            'this is a mailbox description')
      assert_equal 'Folders in mailbox mailbox1 are not valid', mailbox.errors
                                                                       .first
    end
  end
end

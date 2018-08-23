# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../models/imap_config'

class ImapConfigTest < Test::Unit::TestCase
  context 'validate imap config' do
    def test_imap_config_valid
      imap_config = ImapConfig.new(mailboxname: 'mailbox',
                                   username: 'user',
                                   password: 'password',
                                   hostname: 'hostname.example.com',
                                   port: 143,
                                   ssl: false)

      assert_equal [], imap_config.errors
    end

    def test_imap_config_invalid_username_not_defined
      imap_config = ImapConfig.new(mailboxname: 'mailbox',
                                   username: nil,
                                   password: 'password',
                                   hostname: 'hostname.example.com',
                                   port: 143,
                                   ssl: false)

      assert_equal 'username is not defined in mailbox mailbox options',
                   imap_config.errors.first
    end

    def test_imap_config_invalid_username_and_password_not_defined
      imap_config = ImapConfig.new(mailboxname: 'mailbox',
                                   username: nil,
                                   password: nil,
                                   hostname: 'hostname.example.com',
                                   port: 143,
                                   ssl: false)

      assert_equal ['username is not defined in mailbox mailbox options',
                    'password is not defined in mailbox mailbox options'],
                   imap_config.errors
    end

    def test_imap_config_valid_port_not_defined
      imap_config = ImapConfig.new(mailboxname: 'mailbox',
                                   username: 'user',
                                   password: 'password',
                                   hostname: 'hostname.example.com',
                                   port: nil,
                                   ssl: false)

      assert_equal [], imap_config.errors
    end
  end
end

# frozen_string_literal: true

require_relative 'model'
require_relative '../lib/locales_helper'

class ImapConfig < Model
  attr_reader :mailboxname, :hostname, :username,
              :password, :port, :ssl

  def initialize(mailboxname:, username:, password:, hostname:, port: nil, ssl: nil)
    super()
    @mailboxname = mailboxname
    @username = username
    @password = password
    @hostname = hostname
    port ||= 143
    @port = port
    ssl ||= false
    @ssl = ssl

    validate
  end

  def validate
    imap_options = { hostname: hostname,
                     username: username,
                     password: password }
    imap_options.each do |key, value|
      if value.nil?
        errors << t('error_messages.option_not_defined',
                    option: key, mailbox: mailboxname)
      end
    end
  end
end

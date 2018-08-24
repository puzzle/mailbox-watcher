# frozen_string_literal: true

require 'net/imap'
require 'base64'
require_relative 'locales_helper'

class ImapConnector
  attr_reader :errors

  def initialize(imap_config)
    @imap_config = imap_config
    @errors = []
  end

  def mails_from_folder(foldername)
    return unless connect

    imap.select(foldername)
    imap.search(['ALL'])
  rescue Net::IMAP::Error => error
    errors << error.message
    return
  end

  def mail(foldername, id)
    return unless connect

    imap.select(foldername)
    imap.fetch(id, 'ENVELOPE').first.attr['ENVELOPE']
  rescue Net::IMAP::Error => error
    if error.message.include? 'No matching messages'
      errors << t('error_messages.mail_does_not_exist')
      return
    end
    errors << error.message
    return
  end

  def most_recent_mail_date(foldername)
    return unless connect

    imap.select(foldername)
    mail_id = imap.search(['ALL']).last
    extract_date(foldername, mail_id)
  rescue Net::IMAP::Error => error
    errors << error.message
    return
  end

  private

  attr_reader :imap_config, :imap

  def connect
    @imap = Net::IMAP.new(imap_config.hostname, port: imap_config.port)
    imap.starttls({}, true) if imap_config.ssl
    authenticate
  rescue SocketError
    errors << t('error_messages.server_not_reachable',
                hostname: imap_config.hostname)
    false
  end

  def authenticate
    imap.authenticate('LOGIN', username, password)
    true
  rescue Net::IMAP::Error => error
    errors << error.message
    false
  end

  def username
    Base64.decode64(imap_config.username)
  end

  def password
    Base64.decode64(imap_config.password)
  end

  def extract_date(foldername, mail_id)
    mail_date = mail(foldername, mail_id).date
    Time.parse(mail_date)
  end
end

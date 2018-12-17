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
  rescue Net::IMAP::Error
    errors << t('error_messages.folder_does_not_exist', foldername: foldername)
    nil
  end

  def mail(foldername, id)
    return unless connect

    imap.select(foldername)
    raise Net::IMAP::Error, 'Invalid sequence in Fetch' unless id

    imap.fetch(id, 'ENVELOPE').first.attr['ENVELOPE']
  rescue Net::IMAP::Error => error
    errors << error_message(error, foldername)
    nil
  end

  def mails(foldername, ids)
    return unless connect

    imap.select(foldername)
    imap.fetch(ids, 'ENVELOPE')
  rescue Net::IMAP::Error => error
    errors << error_message(error, foldername)
    nil
  end

  def most_recent_mail_date(foldername)
    return unless connect

    imap.select(foldername)
    mail_id = imap.search(['ALL']).last
    extract_date(foldername, mail_id)
  rescue Net::IMAP::Error => error
    errors << error_message(error, foldername)
    nil
  end

  private

  attr_reader :imap_config, :imap

  def connect
    return unless imap_config

    new_imap
    imap.starttls({}, true) if imap_config.ssl
    authenticate
  rescue SocketError
    errors << t('error_messages.server_not_reachable',
                hostname: imap_config.hostname)
    false
  end

  def new_imap
    @imap = Net::IMAP.new(imap_config.hostname, port: imap_config.port)
  end

  def authenticate
    imap.authenticate('LOGIN', username, password)
    true
  rescue Net::IMAP::Error
    errors << t('error_messages.imap_login_failed',
                hostname: imap_config.hostname)
    false
  end

  def username
    return '' unless imap_config.username

    Base64.decode64(imap_config.username)
  end

  def password
    return '' unless imap_config.password

    Base64.decode64(imap_config.password)
  end

  def extract_date(foldername, mail_id)
    mail = mail(foldername, mail_id)
    return nil unless mail

    Time.parse(mail.date).utc
  end

  def error_message(error, foldername)
    return t('error_messages.mail_does_not_exist') if error.message.include?('No matching messages')
    if error.message.include?('Invalid sequence in Fetch')
      return t('error_messages.folder_empty', foldername: foldername)
    end

    error.message
  end
end

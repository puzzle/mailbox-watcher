# frozen_string_literal: true

require 'net/imap'
require_relative 'locales_helper'

class ImapConnector
  attr_reader :errors

  def initialize(username:, password:, hostname:, port: 143, ssl: false)
    @username = username
    @password = password
    @errors = []
    @hostname = hostname
    @port = port
    @ssl = ssl
  end

  def mails_from_folder(foldername)
    return unless connect
    imap.select(foldername)
    imap.search(['ALL'])
  rescue Net::IMAP::Error => error
    errors << error.message
  end

  # integrate this method in a step
  def latest_mail_older_than?(foldername, date)
    return unless connect
    latest_mail_date = most_recent_mail_date(foldername)

    if latest_mail_date > date
      hours = latest_mail_age_in_hours(latest_mail_date)
      errors << t('error_messages.latest_mail_to_old', hours: hours)
      return true
    end
    false
  rescue Net::IMAP::Error => error
    errors << error.message
  end

  def most_recent_mail_date(foldername)
    imap.select(foldername)
    mail_id = imap.search(['ALL']).last
    extract_date(mail_id)
  end

  private

  def connect
    @imap = Net::IMAP.new(@hostname, port: @port)
    imap.starttls({}, true) if @ssl
    authenticate
  rescue SocketError
    errors << t('error_messages.server_not_reachable', hostname: @hostname)
    false
  end

  def authenticate
    imap.authenticate('LOGIN', username, password)
    true
  rescue Net::IMAP::Error => error
    errors << error.message
    false
  end

  def latest_mail_age_in_hours(latest_mail_date)
    ((Time.now - latest_mail_date) / 3600).round
  end

  def extract_date(mail_id)
    mail_date = imap.fetch(mail_id, 'ENVELOPE').first.attr['ENVELOPE'].date
    Time.parse(mail_date)
  end

  attr_reader :username, :password, :imap
end

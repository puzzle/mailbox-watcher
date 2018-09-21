# frozen_string_literal: true

require_relative 'step'
require_relative '../models/mail'

class CheckMailbox < Step
  def initialize(project)
    super()
    @project = project
  end

  def execute
    mailbox_states = project.mailboxes.collect do |mailbox|
      @imap_connector = ImapConnector.new(mailbox.imap_config)
      results = mailbox.folders.collect do |folder|
        error_subject_found = check_subject!(folder)
        error_max_age_found = check_age!(folder)
        next false if rules_not_present?(folder)
        error_subject_found && error_max_age_found
      end
      mailbox.status = mailbox_status(mailbox, results)
    end
    step_status(mailbox_states)
  end

  private

  attr_reader :project, :imap_connector

  def check_subject!(folder)
    mail_ids = imap_connector.mails_from_folder(folder.name)
    return false unless mail_ids
    folder.number_of_mails = mail_ids.count

    return true if folder.alert_regex.nil?

    mails = imap_connector.mails(folder.name, mail_ids)
    return false unless mails
    mail_states = mails.collect do |mail|
      mail = mail.attr['ENVELOPE']
      regex = /#{folder.alert_regex}/

      if regex.match(mail.subject)
        folder.alert_mails << alert_mail(mail)
        folder.errors << t('error_messages.regex_matches_with_subject',
                           alert_regex: folder.alert_regex,
                           folder: folder.name)
        next false
      end
      true
    end

    mail_states.include?(false) ? false : true
  end

  def alert_mail(mail)
    first_from = mail.from.first
    from =
      first_from.name || "#{mail.from.first.mailbox}@#{mail.from.first.host}"

    Mail.new(mail.subject, from, mail.date)
  end

  def check_age!(folder)
    return true if folder.max_age.nil?

    latest_mail_date = imap_connector.most_recent_mail_date(folder.name)
    return false unless latest_mail_date
    latest_mail_older_than?(folder, latest_mail_date)
  end

  def latest_mail_older_than?(folder, latest_mail_date)
    max_age = Time.now - (folder.max_age * 3600)

    if latest_mail_date < max_age
      hours = hours_above_max_age(latest_mail_date)
      folder.errors << t('error_messages.latest_mail_to_old', hours: hours)
      return false
    end
    true
  end

  def hours_above_max_age(latest_mail_date)
    ((Time.now - latest_mail_date) / 3600).round
  end

  def rules_not_present?(folder)
    folder.alert_regex.nil? && folder.max_age.nil?
  end

  def mailbox_status(mailbox, results)
    mailbox.errors.concat imap_connector.errors.uniq
    results.include?(false) ? 'error' : 'ok'
  end

  def step_status(results)
    if results.include?('error')
      @state = 404
      false
    else
      @state = 200
      true
    end
  end
end

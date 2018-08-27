# frozen_string_literal: true

require_relative 'step'
require 'time'

class GenerateReport < Step
  def initialize(project)
    super()
    @project = project
  end

  def execute
    @state = 200
    JSON.generate(project_hash)
  end

  private

  attr_reader :project

  def project_hash
    {
      'projectname' => project.projectname,
      'description' => project.description,
      'mailboxes' => mailboxes_hash
    }
  end

  def mailboxes_hash
    project.mailboxes.collect do |mailbox|
      {
        'name' => mailbox.name,
        'description' => mailbox.description,
        'status' => mailbox.status,
        'folders' => folders_hash(mailbox)
      }
    end
  end

  def folders_hash(mailbox)
    mailbox.folders.collect do |folder|
      {
        'name' => folder.name,
        'description' => folder.description,
        'max-age' => max_age(folder.max_age),
        'alert-regex' => folder.alert_regex,
        'number-of-mails' => folder.number_of_mails,
        'alerts' => folder.errors,
        'alert-mails' => mails_hash(folder)
      }
    end
  end

  def mails_hash(folder)
    folder.alert_mails.collect do |mail|
      {
        'subject' => mail.subject,
        'sender' => mail.sender,
        'received-at' => format_date(mail.received_at)
      }
    end
  end

  def format_date(date)
    t = Time.parse(date)
    t.strftime('%d.%m.%Y')
  end

  def max_age(hours)
    return unless hours
    hours > 24 ? (hours / 24).to_s + 'd' : hours.to_s + 'h'
  end
end

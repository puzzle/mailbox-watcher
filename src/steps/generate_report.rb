# frozen_string_literal: true

require_relative 'step'
require 'time'

class GenerateReport < Step
  def initialize(project)
    super()
    @project = project
    @included = []
  end

  def execute
    @state = 200
    JSON.generate(project_hash)
  end

  private

  attr_reader :project, :included
  attr_writer :included

  def project_hash
    { 'data' => {
      'type' => 'project',
      'id' => project.projectname,
      'attributes' => project_attributes(project),
      'relationships' => project.mailboxes.collect do |mailbox|
                           {
                             'mailbox' => {
                               'data' => {
                                 'type' => 'mailbox',
                                 'id' => mailbox.name
                               }
                             }
                           }
                         end
    },
      'included' => [mailboxes_hash, included].flatten }
  end

  def project_attributes(project)
    {
      'projectname' => project.projectname,
      'description' => project.description,
      'alerts' => project.errors
    }
  end

  def mailboxes_hash
    project.mailboxes.collect do |mailbox|
      included.concat folders_hash(mailbox)
      {
        'type' => 'mailbox',
        'id' => mailbox.name,
        'attributes' => mailbox_attributes(mailbox),
        'relationships' => {
          'project' => {
            'data' => {
              'type' => 'project',
              'id' => project.projectname
            }
          },
          'folders' => mailbox_folders(mailbox)
        }
      }
    end
  end

  def mailbox_attributes(mailbox)
    {
      'name' => mailbox.name,
      'description' => mailbox.description,
      'status' => mailbox.status,
      'alerts' => mailbox.errors
    }
  end

  def mailbox_folders(mailbox)
    {
      'data' => mailbox.folders.collect do |folder|
        {
          'type' => 'folder',
          'id' => folder.name
        }
      end
    }
  end

  def folders_hash(mailbox)
    mailbox.folders.collect do |folder|
      included.concat mails_hash(folder)
      {
        'type' => 'folder',
        'id' => folder.name,
        'attributes' => folder_attributes(folder),
        'relationships' => {
          'mailbox' => {
            'data' => {
              'type' => 'mailbox',
              'id' => mailbox.name
            }
          },
          'mails' => folder_mails(folder)
        }
      }
    end
  end

  def folder_attributes(folder)
    {
      'name' => folder.name,
      'description' => folder.description,
      'max-age' => format_max_age(folder.max_age),
      'alert-regex' => folder.alert_regex,
      'number-of-mails' => folder.number_of_mails,
      'alerts' => folder.errors.uniq
    }
  end

  def folder_mails(folder)
    {
      'data' => folder.alert_mails.collect do |mail|
        {
          'type' => 'mail',
          'id' => mail.subject + mail.received_at
        }
      end
    }
  end

  def mails_hash(folder)
    folder.alert_mails.collect do |mail|
      {
        'type' => 'mail',
        'id' => mail.subject + mail.received_at,
        'attributes' => mail_attributes(mail),
        'relationships' => {
          'folder' => {
            'data' => {
              'type' => 'folder',
              'id' => folder.name
            }
          }
        }
      }
    end
  end

  def mail_attributes(mail)
    {
      'subject' => mail.subject,
      'sender' => mail.sender,
      'received-at' => format_date(mail.received_at)
    }
  end

  def format_date(date)
    t = Time.parse(date).utc
    t.strftime('%H:%M, %d.%m.%Y')
  end

  def format_max_age(hours)
    return nil unless hours

    hours > 24 ? (hours / 24).to_s + 'd' : hours.to_s + 'h'
  end
end

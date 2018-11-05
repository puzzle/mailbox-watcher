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
      'attributes' => {
        'projectname' => project.projectname,
        'description' => project.description,
        'alerts' => project.errors
      },
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

  def mailboxes_hash
    project.mailboxes.collect do |mailbox|
      included.concat folders_hash(mailbox)
      {
        'type' => 'mailbox',
        'id' => mailbox.name,
        'attributes' => {
          'name' => mailbox.name,
          'description' => mailbox.description,
          'status' => mailbox.status,
          'alerts' => mailbox.errors
        },
        'relationships' => {
          'project' => {
            'data' => {
              'type' => 'project',
              'id' => project.projectname
            }
          },
          'folders' => {
            'data' => mailbox.folders.collect do |folder|
              {
                'type' => 'folder',
                'id' => folder.name
              }
            end
          }
        }
      }
    end
  end

  def folders_hash(mailbox)
    mailbox.folders.collect do |folder|
      included.concat mails_hash(folder)
      {
        'type' => 'folder',
        'id' => folder.name,
        'attributes' => {
          'name' => folder.name,
          'description' => folder.description,
          'max-age' => format_max_age(folder.max_age),
          'alert-regex' => folder.alert_regex,
          'number-of-mails' => folder.number_of_mails,
          'alerts' => folder.errors.uniq
        },
        'relationships' => {
          'mailbox' => {
            'data' => {
              'type' => 'mailbox',
              'id' => mailbox.name
            }
          },
          'mails' => {
            'data' => folder.alert_mails.collect do |mail|
              {
                'type' => 'mail',
                'id' => mail.subject + mail.received_at
              }
            end
          }
        }
      }
    end
  end

  def mails_hash(folder)
    folder.alert_mails.collect do |mail|
      {
        'type' => 'mail',
        'id' => mail.subject + mail.received_at,
        'attributes' => {
          'subject' => mail.subject,
          'sender' => mail.sender,
          'received-at' => format_date(mail.received_at)
        },
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

  def format_date(date)
    t = Time.parse(date)
    t.strftime('%d.%m.%Y')
  end

  def format_max_age(hours)
    return nil unless hours
    hours > 24 ? (hours / 24).to_s + 'd' : hours.to_s + 'h'
  end
end

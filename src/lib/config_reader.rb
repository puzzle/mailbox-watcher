# frozen_string_literal: true

require 'yaml'
require_relative 'locales_helper'
require_relative '../models/project'
require_relative '../models/mailbox'
require_relative '../models/imap_config'
require_relative '../models/folder'

class ConfigReader
  attr_reader :errors

  def initialize
    @errors = []
  end

  def projects
    projectnames.collect do |projectname|
      filepath = config_file_path(projectname)
      @config_file = load_file(filepath)
      next unless secret_file_present?(projectname)

      create_project(projectname)
    end.compact
  end

  def projectnames
    filenames = Dir.glob(["#{config_path}/*.yml"])
    filenames.collect do |filename|
      File.basename(filename, '.yml')
    end
  end

  private

  def project_description
    config_file.dig('description')
  end

  def mailbox_description(mailboxname)
    config_file.dig('mailboxes',
                    mailboxname,
                    'description')
  end

  def folder_description(mailboxname, foldername)
    config_file.dig('mailboxes',
                    mailboxname,
                    'folders',
                    foldername,
                    'description')
  end

  def alert_regex(mailboxname, foldername)
    config_file.dig('mailboxes',
                    mailboxname,
                    'folders',
                    foldername,
                    'alert-regex')
  end

  def max_age(mailboxname, foldername)
    config_file.dig('mailboxes',
                    mailboxname,
                    'folders',
                    foldername,
                    'max-age')
  end

  def imap_config(mailboxname)
    secret_file.dig('mailboxes',
                    mailboxname)
  end

  def mailboxes
    mailboxes = config_file.dig('mailboxes')
    mailboxes&.keys
  end

  def folders(mailboxname)
    folders = config_file.dig('mailboxes',
                              mailboxname,
                              'folders')
    folders&.keys
  end

  def create_project(projectname)
    Project.new(projectname, create_mailboxes, project_description)
  end

  def create_mailboxes
    return [] unless mailboxes

    mailboxes.collect do |mailboxname|
      description = mailbox_description(mailboxname)
      folders = create_folders(mailboxname)
      imap_config = create_imap_config(mailboxname)
      Mailbox.new(mailboxname, folders, imap_config, description)
    end
  end

  def create_imap_config(mailboxname)
    imap_config = imap_config(mailboxname)
    ImapConfig.new(mailboxname: mailboxname,
                   username: imap_config['username'],
                   password: imap_config['password'],
                   hostname: imap_config['hostname'],
                   options: { port: imap_config['port'], ssl: imap_config['ssl'] })
  rescue StandardError
    nil
  end

  def create_folders(mailboxname)
    return [] unless folders(mailboxname)

    folders(mailboxname).collect do |foldername|
      max_age = max_age(mailboxname, foldername)
      alert_regex = alert_regex(mailboxname, foldername)
      description = folder_description(mailboxname, foldername)
      Folder.new(foldername, max_age, alert_regex, description)
    end
  end

  def secret_file_present?(projectname)
    file_path = secret_file_path(projectname)

    if File.exist?(file_path)
      @secret_file = load_file(file_path)
      return true
    end
    errors << t('error_messages.secret_file_does_not_exist',
                projectname: projectname)
    false
  end

  def config_file_path(projectname)
    "#{config_path}/#{projectname.downcase}.yml"
  end

  def secret_file_path(projectname)
    "#{secret_path}/#{projectname.downcase}.yml"
  end

  def config_path
    ENV['CONFIG_PATH']
  end

  def secret_path
    ENV['SECRET_PATH']
  end

  def load_file(file_path)
    YAML.load_file(file_path)
  end

  attr_reader :config_file, :secret_file
end

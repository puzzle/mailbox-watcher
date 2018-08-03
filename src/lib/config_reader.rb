# frozen_string_literal: true

require 'yaml'
require_relative 'locales_helper'

class ConfigReader
  attr_reader :projectname, :errors

  def initialize(projectname)
    @projectname = projectname
    @errors = []
  end

  def validate_config_file
    file_present?('config')
    config_file_valid?
  rescue RuntimeError => error
    errors << error.message
    false
  end

  def validate_secret_file
    file_present?('secrets')
    secret_file_valid?
  rescue RuntimeError => error
    errors << error.message
    false
  end

  def project_description
    config_file['description']
  end

  def mailbox_description(mailboxname)
    config_file['mailboxes'][mailboxname]['description']
  end

  def folder_description(mailboxname, foldername)
    config_file['mailboxes'][mailboxname]['folders'][foldername]['description']
  end

  def alert_regex(mailboxname, foldername)
    config_file['mailboxes'][mailboxname]['folders'][foldername]['alert-regex']
  end

  def max_age(mailboxname, foldername)
    config_file['mailboxes'][mailboxname]['folders'][foldername]['max-age']
  end

  def imap_config(mailboxname)
    secret_file['mailboxes'][mailboxname]
  end

  private

  def file_present?(type)
    file_path = yaml_path(type)

    if File.exist?(file_path)
      if type == 'config'
        @config_file = load_file(file_path)
      else
        @secret_file = load_file(file_path)
      end
      return true
    end

    raise(t('error_messages.file_does_not_exist', filename: file_path))
  end

  def base_path
    File.expand_path('../../../', __FILE__)
  end

  def yaml_path(type)
    "#{base_path}/#{type}/#{projectname.downcase}.yml"
  end

  def load_file(filename)
    YAML.load_file(filename)
  end

  def config_file_valid?
    mailboxes.each do |mailbox|
      folders(mailbox).each do |folder|
        rules_valid = alert_regex(mailbox, folder).is_a?(String) || max_age(mailbox, folder).is_a?(Integer)
        raise(t('error_messages.rules_not_valid', folder: folder)) unless rules_valid
      end
    end
    true
  rescue RuntimeError => error
    errors << error.message
    false
  end

  def secret_file_valid?
    mailboxes.each do |mailbox|
      return false if options_errors(mailbox).any?
    end
    true
  rescue RuntimeError => error
    errors << error.message
    false
  end
  
  def options_errors(mailboxname)
    ['hostname', 'username', 'password'].each do |option|
      value = secret_file['mailboxes'][mailboxname][option]
      unless value.is_a?(String)
        errors << t('error_messages.option_not_defined', {option: option.capitalize, mailbox: mailboxname})
      end
    end
    errors
  end

  def mailboxes
    raise if mailbox_names.empty?
    mailbox_names
  rescue StandardError
    raise(t('error_messages.mailboxes_not_valid', project: projectname))
  end

  def mailbox_names
    file = config_file.nil? ? secret_file : config_file
    file['mailboxes'].keys
  end

  def folders(mailbox)
    folders = config_file['mailboxes'][mailbox]['folders'].keys
    raise if folders.empty?
    folders
  rescue StandardError
    raise(t('error_messages.folders_not_valid', mailbox: mailbox))
  end
  
  attr_reader :config_file, :secret_file
end

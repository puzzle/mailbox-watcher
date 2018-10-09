# frozen_string_literal: true

require_relative 'model'
require_relative '../lib/locales_helper'

class Mailbox < Model
  attr_reader :name, :folders, :status,
              :description, :imap_config
  attr_writer :status

  def initialize(name, description = '', folders, imap_config)
    super()
    @name = name
    @description = description
    @folders = folders
    @imap_config = imap_config
    @status = nil

    validate
  end

  def validate
    if folders.empty?
      errors << t('error_messages.folders_not_valid',
                  mailbox: @name)
    end
    unless imap_config
      errors << t('error_messages.mailbox_not_defined_in_secret_file',
                  mailbox: @name)
    end
  end
end

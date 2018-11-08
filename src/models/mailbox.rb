# frozen_string_literal: true

require_relative 'model'
require_relative '../lib/locales_helper'

class Mailbox < Model
  attr_reader :name, :folders, :status,
              :description, :imap_config
  attr_writer :status

  def initialize(name, folders, imap_config, description = '')
    super()
    @name = name
    @folders = folders
    @imap_config = imap_config
    @description = description
    @status = nil

    validate
  end

  def validate
    if folders.empty?
      errors << t('error_messages.folders_not_valid',
                  mailbox: @name)
    end
    return if imap_config
    errors << t('error_messages.mailbox_not_defined_in_secret_file',
                mailbox: @name)
  end
end

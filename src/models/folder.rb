# frozen_string_literal: true

require_relative '../lib/locales_helper'

class Folder
  attr_reader :name, :description, :max_age, :alert_regex, :number_of_mails, :alert_mails, :errors
  attr_writer :number_of_mails

  def initialize(name, description = '', max_age, alert_regex)
    @name = name
    @description = description
    @max_age = max_age
    @alert_regex = alert_regex
    @number_of_mails = nil
    @alert_mails = []
    @errors = []

    validate
  end

  def validate
    rules_valid = alert_regex.is_a?(String) || max_age.is_a?(Integer)
    errors << t('error_messages.rules_not_valid',
                folder: @name) unless rules_valid
  end
end

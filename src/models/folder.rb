# frozen_string_literal: true

require_relative 'model'
require_relative '../lib/locales_helper'

class Folder < Model
  attr_reader :name, :description, :max_age,
              :alert_regex, :number_of_mails,
              :alert_mails
  attr_writer :number_of_mails

  def initialize(name, max_age, alert_regex, description = '')
    super()
    @name = name
    @max_age = max_age
    @alert_regex = alert_regex
    @description = description
    @number_of_mails = nil
    @alert_mails = []

    validate
  end

  def validate
    rules = alert_regex.is_a?(String) || max_age.is_a?(Integer)
    errors << t('error_messages.rules_not_valid', folder: @name) unless rules
  end
end

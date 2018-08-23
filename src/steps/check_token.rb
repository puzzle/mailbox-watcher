# frozen_string_literal: true

require_relative 'step'

class CheckToken < Step
  def initialize(token)
    super()
    @sent_token = token
  end

  def execute
    if valid?
      @state = 200
      return true
    end
    @state = 401
    errors << t('error_messages.authentication_failed')
    false
  end

  private

  def valid?
    token == @sent_token
  end

  def token
    ENV['MAIL_MON_TOKEN']
  end
end

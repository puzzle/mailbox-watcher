# frozen_string_literal: true

class Step
  attr_reader :state, :errors

  def initialize
    @state = nil
    @errors = []
  end

  def execute
    raise 'implement in subclass'
  end
end

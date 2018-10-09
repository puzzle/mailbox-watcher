# frozen_string_literal: true

class Model
  attr_reader :errors

  def initialize
    @errors = []
  end

  def validate
    raise 'implement in subclass'
  end
end

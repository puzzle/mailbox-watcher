# frozen_string_literal: true

class Mail
  attr_reader :subject, :sender, :received_at

  def initialize(subject, sender, received_at)
    @subject = subject
    @sender = sender
    @received_at = received_at
  end
end

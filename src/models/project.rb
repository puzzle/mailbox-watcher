# frozen_string_literal: true

require_relative '../lib/locales_helper'

class Project
  attr_reader :projectname, :description, :mailboxes, :errors

  def initialize(projectname, description = '', mailboxes)
    @projectname = projectname
    @description = description
    @mailboxes = mailboxes
    @errors = []

    validate
  end

  def validate
    errors << t('error_messages.mailboxes_not_valid',
                project: projectname) if mailboxes.empty?
  end
end

# frozen_string_literal: true

require_relative 'model'
require_relative '../lib/locales_helper'

class Project < Model
  attr_reader :projectname, :description, :mailboxes

  def initialize(projectname, description = '', mailboxes)
    super()
    @projectname = projectname
    @description = description
    @mailboxes = mailboxes

    validate
  end

  def validate
    if mailboxes.empty?
      errors << t('error_messages.mailboxes_not_valid',
                  project: projectname)
    end
  end
end

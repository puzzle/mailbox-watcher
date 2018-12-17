# frozen_string_literal: true

require_relative 'model'
require_relative '../lib/locales_helper'

class Project < Model
  attr_reader :projectname, :description, :mailboxes

  def initialize(projectname, mailboxes, description = '')
    super()
    @projectname = projectname
    @mailboxes = mailboxes
    @description = description

    validate
  end

  def validate
    return unless mailboxes.empty?

    errors << t('error_messages.mailboxes_not_valid',
                project: projectname)
  end
end

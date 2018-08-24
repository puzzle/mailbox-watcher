# frozen_string_literal: true

require_relative 'step'
require_relative '../lib/config_reader'

class Prepare < Step
  def initialize(projectname)
    super()
    @projectname = projectname
  end

  def execute
    projects.any? ? project : config_errors
  end

  private

  def projects
    @projects ||= config_reader.projects
  end

  def config_reader
    @config_reader ||= ConfigReader.new
  end

  def project
    projects.each do |project|
      @state = 200
      return project if project.projectname == @projectname
    end
    @state = 404
    errors << t('error_messages.project_config_not_found',
                projectname: @projectname)
    nil
  end

  def config_errors
    @state = 404
    errors.concat config_reader.errors
    nil
  end
end

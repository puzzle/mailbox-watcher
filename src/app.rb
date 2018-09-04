# frozen_string_literal: true

require 'yaml'
require 'sinatra'
require 'sinatra/flash'
require 'json'
require 'haml'
require_relative 'lib/imap_connector'
require_relative 'lib/config_reader'
require_relative 'steps/check_token'
require_relative 'steps/prepare'
require_relative 'steps/check_mailbox'
require_relative 'steps/generate_report'

class App < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  # start server: puma

  get '/home' do
    @token = params['token']
    check_token(@token)

    config_reader = ConfigReader.new
    @projectnames = config_reader.projectnames

    flash.now[:danger] = t('index.no_project') if @projectnames.empty?
    haml :index
  end

  get '/:project' do
    @token = params['token']
    check_token(@token)

    projectname = params['project']
    p = Prepare.new(projectname)
    project = p.execute

    c = CheckMailbox.new(project)
    if project
      c.execute
      gr = GenerateReport.new(project)
      @project_data = JSON.parse(gr.execute)
    else
      @project_data = nil
    end

    errors = [p.errors, c.errors, mailbox_errors(project)].reduce([], :concat).flatten
    errors.concat project.errors if project
    flash.now[:danger] = errors unless errors.empty?
    haml :project
  end

  private

  def check_token(sent_token)
    check_token = CheckToken.new(sent_token)

    halt check_token.state, check_token.errors unless check_token.execute
  end

  def mailbox_errors(project)
    return [] unless project

    project
      .mailboxes
      .flat_map do |mailbox|
      [
        mailbox.errors,
        mailbox.imap_config&.errors
      ]
    end.compact
  end
end

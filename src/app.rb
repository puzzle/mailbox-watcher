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

  # openshift liveness check
  get '/healthz' do
    200
  end

  get '/api/projects' do 
    check_token(params['token'])
    config_reader = ConfigReader.new
    return 200, JSON.generate({'projects' => config_reader.projectnames})
  end

  get '/api/projects/:name' do
    check_token(params['token'])
    
    projectname = params['name']
    p = Prepare.new(projectname)
    project = p.execute

    c = CheckMailbox.new(project)
    if project
      project.errors.concat p.errors
      c.execute
      gr = GenerateReport.new(project)
      project_data = gr.execute
      return 200, project_data
    end
    return 404
  end

  # start server: puma
  get '/' do
    redirect "/home?token=#{params['token']}"
  end

  # status for monitoring system
  get '/status' do
    check_token(params['token'])

    p = Prepare.new(params['id'])
    project = p.execute
    return p.state if project.nil?

    c = CheckMailbox.new(project)
    c.execute

    gr = GenerateReport.new(project)
    project_data = JSON.parse(gr.execute)

    error_codes = extract_status_codes(project_data['mailboxes'])
    status = error_codes.include?(500) ? 500 : 200
    return status, status.to_s
  end

  # home with projects
  get '/' do
    @token = params['token']
    check_token(@token)

    config_reader = ConfigReader.new
    @projectnames = config_reader.projectnames

    flash.now[:danger] = t('index.no_project') if @projectnames.empty?
    haml :index
  end

  # project with reports
  get '/:project' do
    @token = params['token']
    check_token(@token)

    projectname = params['project']
    p = Prepare.new(projectname)
    project = p.execute

    c = CheckMailbox.new(project)
    if project
      project.errors.concat p.errors
      c.execute
      gr = GenerateReport.new(project)
      @project_data = JSON.parse(gr.execute)
    end

    errors = [
      p.errors,
      c.errors,
      project&.errors,
      mailbox_errors(project)
    ].flatten
    errors.compact!
    flash.now[:danger] = errors if errors.any?

    haml :project
  end

  private

  def extract_status_codes(mailboxes)
    mailboxes.collect do |mailbox|
      mailbox['status'] == 'ok' ? 200 : 500
    end
  end

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
    end
  end
end

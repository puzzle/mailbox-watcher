# frozen_string_literal: true

require 'yaml'
require 'sinatra'
# require 'sinatra/flash'
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

  # work in progress
  get '/test-config' do
    p = Prepare.new('cryptopus')
    project = p.execute
    return 404, p.errors if project.nil?

    c = CheckMailbox.new(project)
    c.execute

    g = GenerateReport.new(project)
    g.execute

  #  flash[:danger] = 'This is an error'
    haml :index
  end

  get '/:project/:token' do
    @token = params['token']
    ct = CheckToken.new(@token) 
    unless ct.execute
      @errors = ct.errors
      return haml :authentication_failed
    end
  #  projectname = params['project']
  #  p = Prepare.new(projectname)
  #  project = p.execute
  #  c = CheckMailbox.new(project)
  #  c.execute
    @project_data = {
  "projectname": "Cryptopus",
  "description": "This is a description",
  "mailboxes": [
    {
      "name": "cryptopus-example2@mail.ch",
      "status": "ok",
      "folders": [
        {
         "name": "inbox",
         "description": "This is a description",
         "number-of-mails": 33,
         "max-age": 48,
         "alert-regex": "/(Error|Failure)/",
         "alerts": [],
         "alert-mails": []
        }
      ]
    },
    {
      "name": "cryptopus-example3@mail.ch",
      "status": "error",
      "folders": [
        {
         "name": "backup",
         "description": "This is a description",
         "number-of-mails": 8,
         "max-age": 3,
         "alert-regex": "/(Error|Failure)/",
         "alerts": [
           "Latest mail is older than 13 hours.",
           "testalert"
         ],
         "alert-mails": [
           {
             "subject": "Build failed in Jenkins",
             "sender": "build@travis.com",
             "received-at": "22.06.2018"
           },
           {
             "subject": "Still failing",
             "sender": "build@travis.com",
             "received-at": "23.06.2018"
           }
         ]
        },
        {
         "name": "monitoring",
         "number-of-mails": 42,
         "alert-regex": "/(Error|Failure)/",
         "alerts": [],
         "alert-mails": [
           {
             "subject": "Build failed in Jenkins",
             "sender": "build@travis.com",
             "received-at": "22.06.2018"
           },
           {
             "subject": "Still failing",
             "sender": "build@travis.com",
             "received-at": "23.06.2018"
           }
         ]
       } 
     ]
   }    
  ]
}
    haml :project 
    
  end
end

require 'yaml'

class ConfigReader
  
  def initialize(projectname)
    @projectname = projectname
  end

  def project_description
  end

  def mailbox_description(mailboxname)
  end

  def folder_description(mailboxname, foldername)
  end

  def alert_regex(mailboxname, foldername)
  end
  
  def max_age(mailboxname, foldername)
  end

  def imap_config(mailboxname)
  end

  private

  def validate_config_file
  end

  def validate_secret_file
  end
end

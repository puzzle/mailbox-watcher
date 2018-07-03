require 'net/imap'

class ImapConnector

  def initialize(username, password, hostname, port = 143, ssl = nil)
    @username = username
    @password = password
    @imap = Net::IMAP.new(hostname, {port: port, ssl: ssl})
  end

  def authenticate

  end

  private

  attr_reader :username, :password, :imap
end

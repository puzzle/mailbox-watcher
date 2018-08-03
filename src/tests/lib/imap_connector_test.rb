# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/imap_connector'

class ImapConnectorTest < Test::Unit::TestCase
  context 'mails from folder' do
    def test_does_not_return_mails_if_sever_not_reachable
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .raises(SocketError)

      imap_connector.mails_from_folder('inbox')      
      assert_equal 'IMAP-server hostname.example.com not reachable', imap_connector.errors.first
    end

    def test_does_not_return_mails_if_authentication_failed
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate).with('LOGIN', 'bob', '1234').raises(error('authentication failure'))

      imap_connector.mails_from_folder('not-existing-folder')
      assert_equal 'authentication failure', imap_connector.errors.first
    end

    def test_does_not_return_mails_if_folder_not_exist
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .returns(ok_response)
      imap.expects(:select)
          .with('not-existing-folder')
          .raises(error('Mailbox does not exist'))
      imap.expects(:search).never

      imap_connector.mails_from_folder('not-existing-folder')

      assert_equal 'Mailbox does not exist', imap_connector.errors.first
    end

    def test_returns_mails_from_folder
      imap = mock('imap')
      Net::IMAP.expects(:new).with('hostname.example.com', port: 143).returns(imap)
      imap.expects(:authenticate).with('LOGIN', 'bob', '1234').returns(ok_response)
      imap.expects(:select).with('inbox').returns(ok_response)
      imap.expects(:search).with(['ALL']).returns([1, 2, 3])

      assert_equal [1, 2, 3], imap_connector.mails_from_folder('inbox')
    end
  end

  context 'latest mail older than?' do
    def test_does_not_return_latest_mail_older_than_if_sever_not_reachable
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .raises(SocketError)

      time = Time.new(2018, 7, 31, 13)
      imap_connector.latest_mail_older_than?('inbox', time)
      assert_equal 'IMAP-server hostname.example.com not reachable', imap_connector.errors.first
    end

    def test_does_not_return_latest_mail_older_than_if_authentication_failed
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate).with('LOGIN', 'bob', '1234').raises(error('authentication failure'))

      time = Time.new(2018, 7, 31, 13)
      imap_connector.latest_mail_older_than?('inbox', time)
      assert_equal 'authentication failure', imap_connector.errors.first
    end

    def test_latest_mail_error_when_target_folder_not_present
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .returns(ok_response)
      imap.expects(:select)
          .with('not-existing-folder')
          .raises(error('Mailbox does not exist'))
      imap.expects(:search).never

      imap_connector.latest_mail_older_than?('not-existing-folder', Time.now)

      assert_equal 'Mailbox does not exist', imap_connector.errors.first
    end

    def test_returns_false_if_latest_mail_younger_than_date
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .returns(ok_response)
      imap.expects(:select)
          .with('inbox')
          .returns(ok_response)
      imap.expects(:search)
          .with(['ALL'])
          .returns([1, 2, 3])
      imap.expects(:fetch)
          .with(3, 'ENVELOPE')
          .returns(fetched_data)

      time = Time.new(2018, 7, 31, 13)
      assert_equal false, imap_connector.latest_mail_older_than?('inbox', time)
    end

    def test_returns_date_if_latest_mail_older_than_date
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .returns(ok_response)
      imap.expects(:select)
          .with('inbox')
          .returns(ok_response)
      imap.expects(:search)
          .with(['ALL'])
          .returns([1, 2, 3])
      imap.expects(:fetch)
          .with(3, 'ENVELOPE')
          .returns(fetched_data)
      Time.expects(:now)
          .returns(Time.new(2018, 8, 1, 1))
          .times(2)

      time = Time.new(2018, 7, 30, 19)
      assert_equal true, imap_connector.latest_mail_older_than?('inbox', time)
      assert_equal 'Latest mail older than 17 hours', imap_connector.errors.first
    end
  end

  private

  def imap_connector
    @imap_connector ||= ImapConnector.new(username: 'bob',
                                          password: '1234',
                                          hostname: 'hostname.example.com')
  end

  def ok_response
    response = Net::IMAP::TaggedResponse.new
    response.name = 'OK'
    response
  end

  def error(error_message)
    Net::IMAP::NoResponseError.new(bad_response(error_message))
  end

  def bad_response(error_message)
    response = Net::IMAP::TaggedResponse.new
    response.name = 'No'
    text = Net::IMAP::ResponseText.new
    text.text = error_message
    response.data = text
    response
  end

  def fetched_data
    data = Net::IMAP::FetchData.new
    data.attr = { 'ENVELOPE' => envelope }
    [data]
  end

  def envelope
    envelope = Net::IMAP::Envelope.new
    envelope.date = 'Tue, 31 Jul 2018 08:00:00 +0200'
    envelope
  end
end
